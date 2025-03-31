// src/modules/order/order.controller.ts
import { Request, Response } from "express";
import {
  createOrder,
  getOrders,
  getOrderById,
  updateOrder,
  deleteOrder,
  getOrderByPrescriptionId,
} from "./order.service";
import { CreateOrderInput, UpdateOrderInput } from "./order.schema";

// Create a new order
export const createOrderHandler = async (req: Request, res: Response) => {
  try {
    const data = req.body as CreateOrderInput;
    const order = await createOrder(data);
    res.status(201).json(order);
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error", error: error });
  }
};

// Get all orders
export const getOrdersHandler = async (req: Request, res: Response) => {
  try {
    const orders = await getOrders();
    res.status(200).json(orders);
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error", error: error });
  }
};

// Get an order by prescription ID
export const getOrderByPrescriptionIdHandler = async (
  req: Request,
  res: Response
) => {
  try {
    const id = parseInt(req.params.id, 10);
    const orders = await getOrderByPrescriptionId(id);
    res.status(200).json(orders);
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error", error: error });
  }
};

// Get an order by ID
export const getOrderByIdHandler = async (
  req: Request,
  res: Response
): Promise<any> => {
  try {
    const id = parseInt(req.params.id, 10);
    const order = await getOrderById(id);

    if (!order) {
      return res.status(404).json({ message: "Order not found" });
    }

    res.status(200).json(order);
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error", error: error });
  }
};

// Update an order
export const updateOrderHandler = async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id, 10);
    const data = req.body as UpdateOrderInput;
    const order = await updateOrder(id, data);
    res.status(200).json(order);
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error", error: error });
  }
};

// Delete an order (soft delete)
export const deleteOrderHandler = async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id, 10);
    await deleteOrder(id);
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error", error: error });
  }
};
