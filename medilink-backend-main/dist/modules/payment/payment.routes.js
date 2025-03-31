"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// src/modules/payment/payment.routes.ts
const express_1 = __importDefault(require("express"));
const payment_controller_1 = require("./payment.controller");
const router = express_1.default.Router();
// Payment routes
router.post("/payments", payment_controller_1.createPaymentHandler);
router.get("/payments", payment_controller_1.getPaymentsHandler);
router.get("/payments/:id", payment_controller_1.getPaymentByIdHandler);
router.put("/payments/:id", payment_controller_1.updatePaymentHandler);
router.delete("/payments/:id", payment_controller_1.deletePaymentHandler);
exports.default = router;
