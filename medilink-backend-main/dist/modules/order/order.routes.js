"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const order_controller_1 = require("./order.controller");
const router = express_1.default.Router();
// Order routes
router.post("/orders", order_controller_1.createOrderHandler);
router.get("/orders", order_controller_1.getOrdersHandler);
router.get("/orders/:id", order_controller_1.getOrderByIdHandler);
router.put("/orders/:id", order_controller_1.updateOrderHandler);
router.delete("/orders/:id", order_controller_1.deleteOrderHandler);
exports.default = router;
