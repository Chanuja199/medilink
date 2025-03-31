import { z } from "zod";

// Schema for creating a medicine
export const createMedicineSchema = z.object({
  name: z.string().min(1, "Name is required"),
  description: z.string().optional(),
  pharmacyId: z
    .number()
    .int()
    .positive("Pharmacy ID must be a positive integer"),
  stock: z.number().int().nonnegative("Stock must be a non-negative integer"),
  price: z.number().nonnegative("Price must be a non-negative number"),
});

// Schema for updating a medicine
export const updateMedicineSchema = z.object({
  name: z.string().min(1, "Name is required").optional(),
  description: z.string().optional(),
  pharmacyId: z
    .number()
    .int()
    .positive("Pharmacy ID must be a positive integer")
    .optional(),
  stock: z
    .number()
    .int()
    .nonnegative("Stock must be a non-negative integer")
    .optional(),
  price: z
    .number()
    .nonnegative("Price must be a non-negative number")
    .optional(),
});

// Type definitions
export type CreateMedicineInput = z.infer<typeof createMedicineSchema>;
export type UpdateMedicineInput = z.infer<typeof updateMedicineSchema>;
