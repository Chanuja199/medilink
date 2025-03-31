import prisma from "../../lib/db";
import { CreateMedicineInput, UpdateMedicineInput } from "./medicine.schemas";

// Create a new medicine
export const createMedicine = async (input: CreateMedicineInput) => {
  return prisma.medicine.create({
    data: {
      ...input,
      createdAt: new Date().toISOString(), // Ensure valid ISO-8601 format
      updatedAt: new Date().toISOString(),
    },
  });
};

// Get all medicines
export const getMedicines = async () => {
  return prisma.medicine.findMany({
    where: { deleteStatus: false },
  });
};

// Get a medicine by ID
export const getMedicineById = async (id: number) => {
  return prisma.medicine.findUnique({
    where: { id, deleteStatus: false },
  });
};

// Update a medicine
export const updateMedicine = async (
  id: number,
  input: UpdateMedicineInput
) => {
  const existingPharmacy = await prisma.medicine.findUnique({
    where: { id: id },
  });
  return prisma.medicine.update({
    where: { id },
    data: {
      ...input,
      updatedAt: new Date().toISOString(),
      createdAt: existingPharmacy?.createdAt,
    },
  });
};

// Delete a medicine (soft delete)
export const deleteMedicine = async (id: number) => {
  return prisma.medicine.update({
    where: { id },
    data: { deleteStatus: true },
  });
};
