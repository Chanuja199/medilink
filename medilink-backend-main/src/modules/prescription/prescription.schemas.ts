import { z } from "zod";

// Schema for creating a prescriptio
export const createPrescriptionSchema = z.object({
  userId: z.string(),
  imageUrl: z.string().url("Invalid URL").optional(),
  text: z.string().min(1, "Text is required").optional(),
});

// Schema for updating a prescription
export const updatePrescriptionSchema = z.object({
  imageUrl: z.string().url("Invalid URL").optional(),
  text: z.string().min(1, "Text is required").optional(),
});

// Type definitions
export type CreatePrescriptionInput = z.infer<typeof createPrescriptionSchema>;
export type UpdatePrescriptionInput = z.infer<typeof updatePrescriptionSchema>;
