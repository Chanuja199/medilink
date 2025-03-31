import { z } from "zod";

// Schema for creating a notification
export const createNotificationSchema = z.object({
  userId: z.number().int().positive("User ID must be a positive integer"),
  message: z.string().min(1, "Message is required"),
  status: z.enum(["unread", "read"]).default("unread"),
});

// Schema for updating a notification
export const updateNotificationSchema = z.object({
  message: z.string().min(1, "Message is required").optional(),
  status: z.enum(["unread", "read"]).optional(),
});

// Type definitions
export type CreateNotificationInput = z.infer<typeof createNotificationSchema>;
export type UpdateNotificationInput = z.infer<typeof updateNotificationSchema>;
