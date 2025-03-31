// src/modules/notification/notification.service.ts
import prisma from "../../lib/db";
import {
  CreateNotificationInput,
  UpdateNotificationInput,
} from "./notification.schema";

// Create a new notification
export const createNotification = async (input: CreateNotificationInput) => {
  try {
    return await prisma.notification.create({
      data: input,
    });
  } catch (error) {
    throw new Error("Failed to create notification");
  }
};

// Get all notifications
export const getNotifications = async () => {
  try {
    return await prisma.notification.findMany({
      where: { deleteStatus: false },
    });
  } catch (error) {
    throw new Error("Failed to fetch notifications");
  }
};

// Get a notification by ID
export const getNotificationById = async (id: number) => {
  try {
    const notification = await prisma.notification.findUnique({
      where: { id, deleteStatus: false },
    });

    if (!notification) {
      throw new Error("Notification not found");
    }

    return notification;
  } catch (error) {
    throw new Error("Failed to fetch notification");
  }
};

// Update a notification
export const updateNotification = async (
  id: number,
  input: UpdateNotificationInput
) => {
  try {
    return await prisma.notification.update({
      where: { id },
      data: input,
    });
  } catch (error) {
    throw new Error("Failed to update notification");
  }
};

// Delete a notification (soft delete)
export const deleteNotification = async (id: number) => {
  try {
    return await prisma.notification.update({
      where: { id },
      data: { deleteStatus: true },
    });
  } catch (error) {
    throw new Error("Failed to delete notification");
  }
};
