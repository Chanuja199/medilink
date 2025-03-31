import express from "express";
import {
  createOrderHandler,
  getOrdersHandler,
  getOrderByIdHandler,
  updateOrderHandler,
  getOrderByPrescriptionIdHandler,
  deleteOrderHandler,
} from "./order.controller";

const router = express.Router();

// Order routes
router.post("/orders", createOrderHandler);
router.get("/orders", getOrdersHandler);
router.get("/prescription-order/:id", getOrderByPrescriptionIdHandler);
router.get("/orders/:id", getOrderByIdHandler);
router.put("/orders/:id", updateOrderHandler);
router.delete("/orders/:id", deleteOrderHandler);

export default router;
