"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteOrderHandler = exports.updateOrderHandler = exports.getOrderByIdHandler = exports.getOrdersHandler = exports.createOrderHandler = void 0;
const order_service_1 = require("./order.service");
// Create a new order
const createOrderHandler = async (req, res) => {
    const data = req.body;
    const order = await (0, order_service_1.createOrder)(data);
    res.status(201).json(order);
};
exports.createOrderHandler = createOrderHandler;
// Get all orders
const getOrdersHandler = async (req, res) => {
    const orders = await (0, order_service_1.getOrders)();
    res.status(200).json(orders);
};
exports.getOrdersHandler = getOrdersHandler;
// Get an order by ID
const getOrderByIdHandler = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    const order = await (0, order_service_1.getOrderById)(id);
    if (!order) {
        return res.status(404).json({ message: "Order not found" });
    }
    res.status(200).json(order);
};
exports.getOrderByIdHandler = getOrderByIdHandler;
// Update an order
const updateOrderHandler = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    const data = req.body;
    const order = await (0, order_service_1.updateOrder)(id, data);
    res.status(200).json(order);
};
exports.updateOrderHandler = updateOrderHandler;
// Delete an order (soft delete)
const deleteOrderHandler = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    await (0, order_service_1.deleteOrder)(id);
    res.status(204).send();
};
exports.deleteOrderHandler = deleteOrderHandler;
