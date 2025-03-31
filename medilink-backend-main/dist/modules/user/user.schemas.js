"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.loginUserSchema = exports.updateUserSchema = exports.createUserSchema = void 0;
const zod_1 = require("zod");
// Schema for creating a user
exports.createUserSchema = zod_1.z.object({
    name: zod_1.z.string().min(1, "Name is required"),
    email: zod_1.z.string().email("Invalid email address"),
    password: zod_1.z.string().min(6, "Password must be at least 6 characters"),
    phone: zod_1.z.string().optional(),
    location: zod_1.z.any().optional(), // JSON data
    role: zod_1.z.enum(["user", "pharmacy", "admin"]).default("user"),
});
// Schema for updating a user
exports.updateUserSchema = zod_1.z.object({
    name: zod_1.z.string().min(1, "Name is required").optional(),
    email: zod_1.z.string().email("Invalid email address").optional(),
    password: zod_1.z
        .string()
        .min(6, "Password must be at least 6 characters")
        .optional(),
    phone: zod_1.z.string().optional(),
    location: zod_1.z.any().optional(), // JSON data
    role: zod_1.z.enum(["user", "pharmacy", "admin"]).optional(),
});
// Schema for user login
exports.loginUserSchema = zod_1.z.object({
    email: zod_1.z.string().email("Invalid email address"),
    password: zod_1.z.string().min(6, "Password must be at least 6 characters"),
});
