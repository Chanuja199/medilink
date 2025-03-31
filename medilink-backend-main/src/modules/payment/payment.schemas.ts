import { z } from "zod";

// Schema for creating a payment
export const createPaymentSchema = z.object({
  orderId: z.number().int().positive("Order ID must be a positive integer"),
  amount: z.number().positive("Amount must be a positive number"),
  paymentMethod: z.enum(["cash", "bank transfer"]),
  status: z.enum(["pending", "completed"]).default("pending"),
});

// Schema for updating a payment
export const updatePaymentSchema = z.object({
  amount: z.number().positive("Amount must be a positive number").optional(),
  paymentMethod: z.enum(["cash", "bank transfer"]).optional(),
  status: z.enum(["pending", "completed"]).optional(),
});

// Type definitions
export type CreatePaymentInput = z.infer<typeof createPaymentSchema>;
export type UpdatePaymentInput = z.infer<typeof updatePaymentSchema>;
