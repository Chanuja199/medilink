"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updatePharmacySchema = exports.createPharmacySchema = void 0;
const zod_1 = require("zod");
// Schema for creating a pharmacy
exports.createPharmacySchema = zod_1.z.object({
    name: zod_1.z.string().min(1, "Name is required"),
    location: zod_1.z.any().optional(), // JSON data
    contactInfo: zod_1.z.any().optional(), // JSON data
    inventory: zod_1.z.any().optional(), // JSON data
});
// Schema for updating a pharmacy
exports.updatePharmacySchema = zod_1.z.object({
    name: zod_1.z.string().min(1, "Name is required").optional(),
    location: zod_1.z.any().optional(), // JSON data
    contactInfo: zod_1.z.any().optional(), // JSON data
    inventory: zod_1.z.any().optional(), // JSON data
});
