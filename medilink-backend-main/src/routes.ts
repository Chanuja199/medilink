// src/routes.ts
import express from "express";
import userRoutes from "./modules/user/user.routes";
import prescriptionRoutes from "./modules/prescription/prescription.routes";
import medicineRoutes from "./modules/medicine/medicine.routes";
import orderRoutes from "./modules/order/order.routes";
import pharmacyRoutes from "./modules/pharmacy/pharmacy.routes";
import paymentRoutes from "./modules/payment/payment.routes";
import notificationRoutes from "./modules/notification/notification.routes";

const router = express.Router();

// Combine all routes
router.use("/api", userRoutes);
router.use("/api", prescriptionRoutes);
router.use("/api", medicineRoutes);
router.use("/api", orderRoutes);
router.use("/api", pharmacyRoutes);
router.use("/api", paymentRoutes);
router.use("/api", notificationRoutes);

export default router;
