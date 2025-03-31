"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateNotificationSchema = exports.createNotificationSchema = void 0;
const zod_1 = require("zod");
// Schema for creating a notification
exports.createNotificationSchema = zod_1.z.object({
    userId: zod_1.z.number().int().positive("User ID must be a positive integer"),
    message: zod_1.z.string().min(1, "Message is required"),
    status: zod_1.z.enum(["unread", "read"]).default("unread"),
});
// Schema for updating a notification
exports.updateNotificationSchema = zod_1.z.object({
    message: zod_1.z.string().min(1, "Message is required").optional(),
    status: zod_1.z.enum(["unread", "read"]).optional(),
});
