// src/modules/payment/payment.service.ts
import prisma from "../../lib/db";
import { CreatePaymentInput, UpdatePaymentInput } from "./payment.schemas";

// Create a new payment
export const createPayment = async (input: CreatePaymentInput) => {
  try {
    return await prisma.payment.create({
      data: input,
    });
  } catch (error) {
    throw new Error("Failed to create payment");
  }
};

// Get all payments
export const getPayments = async () => {
  try {
    return await prisma.payment.findMany({
      where: { deleteStatus: false },
    });
  } catch (error) {
    throw new Error("Failed to fetch payments");
  }
};

// Get a payment by ID
export const getPaymentById = async (id: number) => {
  try {
    const payment = await prisma.payment.findUnique({
      where: { id, deleteStatus: false },
    });

    if (!payment) {
      throw new Error("Payment not found");
    }

    return payment;
  } catch (error) {
    throw new Error("Failed to fetch payment");
  }
};

// Update a payment
export const updatePayment = async (id: number, input: UpdatePaymentInput) => {
  try {
    return await prisma.payment.update({
      where: { id },
      data: input,
    });
  } catch (error) {
    throw new Error("Failed to update payment");
  }
};

// Delete a payment (soft delete)
export const deletePayment = async (id: number) => {
  try {
    return await prisma.payment.update({
      where: { id },
      data: { deleteStatus: true },
    });
  } catch (error) {
    throw new Error("Failed to delete payment");
  }
};
