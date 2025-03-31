// src/modules/order/order.service.ts
import prisma from "../../lib/db";
import { CreateOrderInput, UpdateOrderInput } from "./order.schema";

// Create a new order
export const createOrder = async (input: CreateOrderInput) => {
  const { medicines, ...orderData } = input;

  // Fetch the price of each medicine from the database
  const medicinesWithPrice = await Promise.all(
    medicines.map(async (medicine) => {
      const medicineDetails = await prisma.medicine.findUnique({
        where: { id: medicine.medicineId },
      });

      if (!medicineDetails) {
        throw new Error(`Medicine with ID ${medicine.medicineId} not found`);
      }

      return {
        medicineId: medicine.medicineId,
        quantity: medicine.quantity,
        price: medicineDetails.price, // Fetch the price from the Medicine table
      };
    })
  );

  await prisma.prescription.update({
    where: {
      id: orderData.prescriptionId,
    },
    data: {
      status: "completed",
    },
  });

  return prisma.order.create({
    data: {
      ...orderData,
      orderMedicines: {
        create: medicinesWithPrice, // Include the price in the create operation
      },
    },
    include: {
      orderMedicines: true,
    },
  });
};

// Get all orders
export const getOrders = async () => {
  return prisma.order.findMany({
    where: { deleteStatus: false },
    include: {
      user: true,
      orderMedicines: {
        include: {
          medicine: true,
        },
      },
    },
  });
};

// Get an order by ID
export const getOrderById = async (id: number) => {
  return prisma.order.findUnique({
    where: { id, deleteStatus: false },
    include: {
      orderMedicines: true,
    },
  });
};

export const getOrderByPrescriptionId = async (id: number) => {
  try {
    return await prisma.order.findMany({
      where: { prescriptionId: id },
      include: {
        prescription: true,
        pharmacy: true,
        orderMedicines: {
          include: {
            medicine: true,
          },
        },
      },
    });
  } catch (error) {}
};

// Update an order
export const updateOrder = async (id: number, input: UpdateOrderInput) => {
  return prisma.order.update({
    where: { id },
    data: input,
    include: {
      orderMedicines: true,
    },
  });
};

// Delete an order (soft delete)
export const deleteOrder = async (id: number) => {
  return prisma.order.update({
    where: { id },
    data: { deleteStatus: true },
  });
};
