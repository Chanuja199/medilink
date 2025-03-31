"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateOrderSchema = exports.createOrderSchema = void 0;
// src/modules/order/order.schemas.ts
const zod_1 = require("zod");
// Schema for creating an order
exports.createOrderSchema = zod_1.z.object({
    userId: zod_1.z.number().int().positive("User ID must be a positive integer"),
    pharmacyId: zod_1.z
        .number()
        .int()
        .positive("Pharmacy ID must be a positive integer"),
    prescriptionId: zod_1.z
        .number()
        .int()
        .positive("Prescription ID must be a positive integer")
        .optional(),
    status: zod_1.z
        .enum(["pending", "confirmed", "shipped", "delivered"])
        .default("pending"),
    paymentMethod: zod_1.z.enum(["cash", "bank transfer"]),
    deliveryOption: zod_1.z.enum(["home delivery", "in-store pickup"]),
    medicines: zod_1.z.array(zod_1.z.object({
        medicineId: zod_1.z
            .number()
            .int()
            .positive("Medicine ID must be a positive integer"),
        quantity: zod_1.z
            .number()
            .int()
            .positive("Quantity must be a positive integer"),
    })),
});
// Schema for updating an order
exports.updateOrderSchema = zod_1.z.object({
    status: zod_1.z.enum(["pending", "confirmed", "shipped", "delivered"]).optional(),
    paymentMethod: zod_1.z.enum(["cash", "bank transfer"]).optional(),
    deliveryOption: zod_1.z.enum(["home delivery", "in-store pickup"]).optional(),
});
