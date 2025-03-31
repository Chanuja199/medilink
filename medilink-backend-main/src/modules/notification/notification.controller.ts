// src/modules/notification/notification.controller.ts
import { Request, Response } from "express";
import {
  createNotification,
  getNotifications,
  getNotificationById,
  updateNotification,
  deleteNotification,
} from "./notification.service";
import {
  CreateNotificationInput,
  UpdateNotificationInput,
} from "./notification.schema";

// Create a new notification
export const createNotificationHandler = async (
  req: Request,
  res: Response
) => {
  try {
    const data = req.body as CreateNotificationInput;
    const notification = await createNotification(data);
    res.status(201).json(notification);
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};

// Get all notifications
export const getNotificationsHandler = async (req: Request, res: Response) => {
  try {
    const notifications = await getNotifications();
    res.status(200).json(notifications);
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};

// Get a notification by ID
export const getNotificationByIdHandler = async (
  req: Request,
  res: Response
) => {
  try {
    const id = parseInt(req.params.id, 10);
    const notification = await getNotificationById(id);
    res.status(200).json(notification);
  } catch (error: any) {
    res.status(404).json({ message: error.message });
  }
};

// Update a notification
export const updateNotificationHandler = async (
  req: Request,
  res: Response
) => {
  try {
    const id = parseInt(req.params.id, 10);
    const data = req.body as UpdateNotificationInput;
    const notification = await updateNotification(id, data);
    res.status(200).json(notification);
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};

// Delete a notification (soft delete)
export const deleteNotificationHandler = async (
  req: Request,
  res: Response
) => {
  try {
    const id = parseInt(req.params.id, 10);
    await deleteNotification(id);
    res.status(204).send();
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};
