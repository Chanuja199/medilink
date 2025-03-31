"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteNotification = exports.updateNotification = exports.getNotificationById = exports.getNotifications = exports.createNotification = void 0;
// src/modules/notification/notification.service.ts
const db_1 = __importDefault(require("../../lib/db"));
// Create a new notification
const createNotification = async (input) => {
    try {
        return await db_1.default.notification.create({
            data: input,
        });
    }
    catch (error) {
        throw new Error("Failed to create notification");
    }
};
exports.createNotification = createNotification;
// Get all notifications
const getNotifications = async () => {
    try {
        return await db_1.default.notification.findMany({
            where: { deleteStatus: false },
        });
    }
    catch (error) {
        throw new Error("Failed to fetch notifications");
    }
};
exports.getNotifications = getNotifications;
// Get a notification by ID
const getNotificationById = async (id) => {
    try {
        const notification = await db_1.default.notification.findUnique({
            where: { id, deleteStatus: false },
        });
        if (!notification) {
            throw new Error("Notification not found");
        }
        return notification;
    }
    catch (error) {
        throw new Error("Failed to fetch notification");
    }
};
exports.getNotificationById = getNotificationById;
// Update a notification
const updateNotification = async (id, input) => {
    try {
        return await db_1.default.notification.update({
            where: { id },
            data: input,
        });
    }
    catch (error) {
        throw new Error("Failed to update notification");
    }
};
exports.updateNotification = updateNotification;
// Delete a notification (soft delete)
const deleteNotification = async (id) => {
    try {
        return await db_1.default.notification.update({
            where: { id },
            data: { deleteStatus: true },
        });
    }
    catch (error) {
        throw new Error("Failed to delete notification");
    }
};
exports.deleteNotification = deleteNotification;
