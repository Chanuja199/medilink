"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deletePayment = exports.updatePayment = exports.getPaymentById = exports.getPayments = exports.createPayment = void 0;
// src/modules/payment/payment.service.ts
const db_1 = __importDefault(require("../../lib/db"));
// Create a new payment
const createPayment = async (input) => {
    try {
        return await db_1.default.payment.create({
            data: input,
        });
    }
    catch (error) {
        throw new Error("Failed to create payment");
    }
};
exports.createPayment = createPayment;
// Get all payments
const getPayments = async () => {
    try {
        return await db_1.default.payment.findMany({
            where: { deleteStatus: false },
        });
    }
    catch (error) {
        throw new Error("Failed to fetch payments");
    }
};
exports.getPayments = getPayments;
// Get a payment by ID
const getPaymentById = async (id) => {
    try {
        const payment = await db_1.default.payment.findUnique({
            where: { id, deleteStatus: false },
        });
        if (!payment) {
            throw new Error("Payment not found");
        }
        return payment;
    }
    catch (error) {
        throw new Error("Failed to fetch payment");
    }
};
exports.getPaymentById = getPaymentById;
// Update a payment
const updatePayment = async (id, input) => {
    try {
        return await db_1.default.payment.update({
            where: { id },
            data: input,
        });
    }
    catch (error) {
        throw new Error("Failed to update payment");
    }
};
exports.updatePayment = updatePayment;
// Delete a payment (soft delete)
const deletePayment = async (id) => {
    try {
        return await db_1.default.payment.update({
            where: { id },
            data: { deleteStatus: true },
        });
    }
    catch (error) {
        throw new Error("Failed to delete payment");
    }
};
exports.deletePayment = deletePayment;
