"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updatePrescriptionSchema = exports.createPrescriptionSchema = void 0;
const zod_1 = require("zod");
// Schema for creating a prescription
exports.createPrescriptionSchema = zod_1.z.object({
    userId: zod_1.z.number().int().positive("User ID must be a positive integer"),
    imageUrl: zod_1.z.string().url("Invalid URL").optional(),
    text: zod_1.z.string().min(1, "Text is required").optional(),
});
// Schema for updating a prescription
exports.updatePrescriptionSchema = zod_1.z.object({
    imageUrl: zod_1.z.string().url("Invalid URL").optional(),
    text: zod_1.z.string().min(1, "Text is required").optional(),
});
