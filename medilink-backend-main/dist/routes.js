"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// src/routes.ts
const express_1 = __importDefault(require("express"));
const user_routes_1 = __importDefault(require("./modules/user/user.routes"));
const prescription_routes_1 = __importDefault(require("./modules/prescription/prescription.routes"));
const medicine_routes_1 = __importDefault(require("./modules/medicine/medicine.routes"));
const order_routes_1 = __importDefault(require("./modules/order/order.routes"));
const pharmacy_routes_1 = __importDefault(require("./modules/pharmacy/pharmacy.routes"));
const payment_routes_1 = __importDefault(require("./modules/payment/payment.routes"));
const notification_routes_1 = __importDefault(require("./modules/notification/notification.routes"));
const router = express_1.default.Router();
// Combine all routes
router.use("/api", user_routes_1.default);
router.use("/api", prescription_routes_1.default);
router.use("/api", medicine_routes_1.default);
router.use("/api", order_routes_1.default);
router.use("/api", pharmacy_routes_1.default);
router.use("/api", payment_routes_1.default);
router.use("/api", notification_routes_1.default);
exports.default = router;
