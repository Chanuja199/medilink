"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteNotificationHandler = exports.updateNotificationHandler = exports.getNotificationByIdHandler = exports.getNotificationsHandler = exports.createNotificationHandler = void 0;
const notification_service_1 = require("./notification.service");
// Create a new notification
const createNotificationHandler = async (req, res) => {
    try {
        const data = req.body;
        const notification = await (0, notification_service_1.createNotification)(data);
        res.status(201).json(notification);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
};
exports.createNotificationHandler = createNotificationHandler;
// Get all notifications
const getNotificationsHandler = async (req, res) => {
    try {
        const notifications = await (0, notification_service_1.getNotifications)();
        res.status(200).json(notifications);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
};
exports.getNotificationsHandler = getNotificationsHandler;
// Get a notification by ID
const getNotificationByIdHandler = async (req, res) => {
    try {
        const id = parseInt(req.params.id, 10);
        const notification = await (0, notification_service_1.getNotificationById)(id);
        res.status(200).json(notification);
    }
    catch (error) {
        res.status(404).json({ message: error.message });
    }
};
exports.getNotificationByIdHandler = getNotificationByIdHandler;
// Update a notification
const updateNotificationHandler = async (req, res) => {
    try {
        const id = parseInt(req.params.id, 10);
        const data = req.body;
        const notification = await (0, notification_service_1.updateNotification)(id, data);
        res.status(200).json(notification);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
};
exports.updateNotificationHandler = updateNotificationHandler;
// Delete a notification (soft delete)
const deleteNotificationHandler = async (req, res) => {
    try {
        const id = parseInt(req.params.id, 10);
        await (0, notification_service_1.deleteNotification)(id);
        res.status(204).send();
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
};
exports.deleteNotificationHandler = deleteNotificationHandler;
