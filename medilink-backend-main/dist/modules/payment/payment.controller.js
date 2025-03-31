"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deletePaymentHandler = exports.updatePaymentHandler = exports.getPaymentByIdHandler = exports.getPaymentsHandler = exports.createPaymentHandler = void 0;
const payment_service_1 = require("./payment.service");
// Create a new payment
const createPaymentHandler = async (req, res) => {
    try {
        const data = req.body;
        const payment = await (0, payment_service_1.createPayment)(data);
        res.status(201).json(payment);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
};
exports.createPaymentHandler = createPaymentHandler;
// Get all payments
const getPaymentsHandler = async (req, res) => {
    try {
        const payments = await (0, payment_service_1.getPayments)();
        res.status(200).json(payments);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
};
exports.getPaymentsHandler = getPaymentsHandler;
// Get a payment by ID
const getPaymentByIdHandler = async (req, res) => {
    try {
        const id = parseInt(req.params.id, 10);
        const payment = await (0, payment_service_1.getPaymentById)(id);
        res.status(200).json(payment);
    }
    catch (error) {
        res.status(404).json({ message: error.message });
    }
};
exports.getPaymentByIdHandler = getPaymentByIdHandler;
// Update a payment
const updatePaymentHandler = async (req, res) => {
    try {
        const id = parseInt(req.params.id, 10);
        const data = req.body;
        const payment = await (0, payment_service_1.updatePayment)(id, data);
        res.status(200).json(payment);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
};
exports.updatePaymentHandler = updatePaymentHandler;
// Delete a payment (soft delete)
const deletePaymentHandler = async (req, res) => {
    try {
        const id = parseInt(req.params.id, 10);
        await (0, payment_service_1.deletePayment)(id);
        res.status(204).send();
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
};
exports.deletePaymentHandler = deletePaymentHandler;
