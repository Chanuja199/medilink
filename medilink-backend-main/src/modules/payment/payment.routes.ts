// src/modules/payment/payment.routes.ts
import express from "express";
import {
  createPaymentHandler,
  getPaymentsHandler,
  getPaymentByIdHandler,
  updatePaymentHandler,
  deletePaymentHandler,
} from "./payment.controller";

const router = express.Router();

// Payment routes
router.post("/payments", createPaymentHandler);
router.get("/payments", getPaymentsHandler);
router.get("/payments/:id", getPaymentByIdHandler);
router.put("/payments/:id", updatePaymentHandler);
router.delete("/payments/:id", deletePaymentHandler);

export default router;
