"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateMedicineSchema = exports.createMedicineSchema = void 0;
const zod_1 = require("zod");
// Schema for creating a medicine
exports.createMedicineSchema = zod_1.z.object({
    name: zod_1.z.string().min(1, "Name is required"),
    description: zod_1.z.string().optional(),
    pharmacyId: zod_1.z
        .number()
        .int()
        .positive("Pharmacy ID must be a positive integer"),
    stock: zod_1.z.number().int().nonnegative("Stock must be a non-negative integer"),
    price: zod_1.z.number().nonnegative("Price must be a non-negative number"),
});
// Schema for updating a medicine
exports.updateMedicineSchema = zod_1.z.object({
    name: zod_1.z.string().min(1, "Name is required").optional(),
    description: zod_1.z.string().optional(),
    pharmacyId: zod_1.z
        .number()
        .int()
        .positive("Pharmacy ID must be a positive integer")
        .optional(),
    stock: zod_1.z
        .number()
        .int()
        .nonnegative("Stock must be a non-negative integer")
        .optional(),
    price: zod_1.z
        .number()
        .nonnegative("Price must be a non-negative number")
        .optional(),
});
