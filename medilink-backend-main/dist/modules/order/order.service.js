"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteOrder = exports.updateOrder = exports.getOrderById = exports.getOrders = exports.createOrder = void 0;
// src/modules/order/order.service.ts
const db_1 = __importDefault(require("../../lib/db"));
// Create a new order
const createOrder = async (input) => {
    const { medicines, ...orderData } = input;
    // Fetch the price of each medicine from the database
    const medicinesWithPrice = await Promise.all(medicines.map(async (medicine) => {
        const medicineDetails = await db_1.default.medicine.findUnique({
            where: { id: medicine.medicineId },
        });
        if (!medicineDetails) {
            throw new Error(`Medicine with ID ${medicine.medicineId} not found`);
        }
        return {
            medicineId: medicine.medicineId,
            quantity: medicine.quantity,
            price: medicineDetails.price, // Fetch the price from the Medicine table
        };
    }));
    return db_1.default.order.create({
        data: {
            ...orderData,
            orderMedicines: {
                create: medicinesWithPrice, // Include the price in the create operation
            },
        },
        include: {
            orderMedicines: true,
        },
    });
};
exports.createOrder = createOrder;
// Get all orders
const getOrders = async () => {
    return db_1.default.order.findMany({
        where: { deleteStatus: false },
        include: {
            orderMedicines: true,
        },
    });
};
exports.getOrders = getOrders;
// Get an order by ID
const getOrderById = async (id) => {
    return db_1.default.order.findUnique({
        where: { id, deleteStatus: false },
        include: {
            orderMedicines: true,
        },
    });
};
exports.getOrderById = getOrderById;
// Update an order
const updateOrder = async (id, input) => {
    return db_1.default.order.update({
        where: { id },
        data: input,
        include: {
            orderMedicines: true,
        },
    });
};
exports.updateOrder = updateOrder;
// Delete an order (soft delete)
const deleteOrder = async (id) => {
    return db_1.default.order.update({
        where: { id },
        data: { deleteStatus: true },
    });
};
exports.deleteOrder = deleteOrder;
