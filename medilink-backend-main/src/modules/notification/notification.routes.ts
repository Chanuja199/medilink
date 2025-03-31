import express from "express";
import {
  createNotificationHandler,
  getNotificationsHandler,
  getNotificationByIdHandler,
  updateNotificationHandler,
  deleteNotificationHandler,
} from "./notification.controller";

const router = express.Router();

// Notification routes
router.post("/notifications", createNotificationHandler);
router.get("/notifications", getNotificationsHandler);
router.get("/notifications/:id", getNotificationByIdHandler);
router.put("/notifications/:id", updateNotificationHandler);
router.delete("/notifications/:id", deleteNotificationHandler);

export default router;
