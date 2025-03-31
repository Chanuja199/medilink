import { z } from "zod";

// Schema for creating a pharmacy
export const createPharmacySchema = z.object({
  name: z.string().min(1, "Name is required"),
  location: z.any().optional(), // JSON data
  contactInfo: z.any().optional(), // JSON data
  inventory: z.any().optional(), // JSON data
  userId: z.number().int().positive("Valid userId is required"), // Required user ID for 1-1 relationship
});

// Schema for updating a pharmacy
export const updatePharmacySchema = z.object({
  name: z.string().min(1, "Name is required").optional(),
  location: z.any().optional(), // JSON data
  contactInfo: z.any().optional(), // JSON data
  inventory: z.any().optional(), // JSON data
  userId: z.number().int().positive("Valid userId is required").optional(),
});

// Type definitions
export type CreatePharmacyInput = z.infer<typeof createPharmacySchema>;
export type UpdatePharmacyInput = z.infer<typeof updatePharmacySchema>;
