"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updatePaymentSchema = exports.createPaymentSchema = void 0;
const zod_1 = require("zod");
// Schema for creating a payment
exports.createPaymentSchema = zod_1.z.object({
    orderId: zod_1.z.number().int().positive("Order ID must be a positive integer"),
    amount: zod_1.z.number().positive("Amount must be a positive number"),
    paymentMethod: zod_1.z.enum(["cash", "bank transfer"]),
    status: zod_1.z.enum(["pending", "completed"]).default("pending"),
});
// Schema for updating a payment
exports.updatePaymentSchema = zod_1.z.object({
    amount: zod_1.z.number().positive("Amount must be a positive number").optional(),
    paymentMethod: zod_1.z.enum(["cash", "bank transfer"]).optional(),
    status: zod_1.z.enum(["pending", "completed"]).optional(),
});
