// src/modules/order/order.schemas.ts
import { z } from "zod";

// Schema for creating an order
export const createOrderSchema = z.object({
  userId: z.number().int().positive("User ID must be a positive integer"),
  pharmacyId: z
    .number()
    .int()
    .positive("Pharmacy ID must be a positive integer"),
  prescriptionId: z
    .number()
    .int()
    .positive("Prescription ID must be a positive integer")
    .optional(),
  status: z
    .enum(["pending", "confirmed", "shipped", "delivered"])
    .default("pending"),
  paymentMethod: z.enum(["cash", "bank transfer"]),
  deliveryOption: z.enum(["home delivery", "in-store pickup"]),
  medicines: z.array(
    z.object({
      medicineId: z
        .number()
        .int()
        .positive("Medicine ID must be a positive integer"),
      quantity: z
        .number()
        .int()
        .positive("Quantity must be a positive integer"),
    })
  ),
});

// Schema for updating an order
export const updateOrderSchema = z.object({
  status: z.enum(["pending", "confirmed", "shipped", "delivered"]).optional(),
  paymentMethod: z.enum(["cash", "bank transfer"]).optional(),
  deliveryOption: z.enum(["home delivery", "in-store pickup"]).optional(),
});

// Type definitions
export type CreateOrderInput = z.infer<typeof createOrderSchema>;
export type UpdateOrderInput = z.infer<typeof updateOrderSchema>;
