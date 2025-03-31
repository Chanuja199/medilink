// src/modules/payment/payment.controller.ts
import { Request, Response } from "express";
import {
  createPayment,
  getPayments,
  getPaymentById,
  updatePayment,
  deletePayment,
} from "./payment.service";
import { CreatePaymentInput, UpdatePaymentInput } from "./payment.schemas";

// Create a new payment
export const createPaymentHandler = async (req: Request, res: Response) => {
  try {
    const data = req.body as CreatePaymentInput;
    const payment = await createPayment(data);
    res.status(201).json(payment);
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};

// Get all payments
export const getPaymentsHandler = async (req: Request, res: Response) => {
  try {
    const payments = await getPayments();
    res.status(200).json(payments);
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};

// Get a payment by ID
export const getPaymentByIdHandler = async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id, 10);
    const payment = await getPaymentById(id);
    res.status(200).json(payment);
  } catch (error: any) {
    res.status(404).json({ message: error.message });
  }
};

// Update a payment
export const updatePaymentHandler = async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id, 10);
    const data = req.body as UpdatePaymentInput;
    const payment = await updatePayment(id, data);
    res.status(200).json(payment);
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};

// Delete a payment (soft delete)
export const deletePaymentHandler = async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id, 10);
    await deletePayment(id);
    res.status(204).send();
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};
