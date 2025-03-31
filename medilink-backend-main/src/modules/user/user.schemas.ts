import { z } from "zod";

// Schema for creating a user
export const createUserSchema = z.object({
  name: z.string().min(1, "Name is required"),
  email: z.string().email("Invalid email address"),
  password: z.string().min(6, "Password must be at least 6 characters"),
  phone: z.string().optional(),
  location: z.any().optional(), // JSON data
  role: z.enum(["user", "pharmacy", "admin"]).default("user"),
});

// Schema for updating a user
export const updateUserSchema = z.object({
  name: z.string().min(1, "Name is required").optional(),
  email: z.string().email("Invalid email address").optional(),
  password: z
    .string()
    .min(6, "Password must be at least 6 characters")
    .optional(),
  phone: z.string().optional(),
  location: z.any().optional(), // JSON data
  role: z.enum(["user", "pharmacy", "admin"]).optional(),
});

// Schema for user login
export const loginUserSchema = z.object({
  email: z.string().email("Invalid email address"),
  password: z.string().min(6, "Password must be at least 6 characters"),
});

// Type definitions
export type CreateUserInput = z.infer<typeof createUserSchema>;
export type UpdateUserInput = z.infer<typeof updateUserSchema>;
export type LoginUserInput = z.infer<typeof loginUserSchema>;
