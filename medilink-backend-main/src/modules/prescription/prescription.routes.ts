import express from "express";
import {
  createPrescriptionHandler,
  getPrescriptionsHandler,
  getPrescriptionByIdHandler,
  updatePrescriptionHandler,
  deletePrescriptionHandler,
  upload,
} from "./prescription.controller";

const router = express.Router();

// Prescription routes
router.post(
  "/prescriptions",
  upload.single("image"),
  createPrescriptionHandler
);
router.get("/prescriptions", getPrescriptionsHandler);
router.get("/prescriptions/:id", getPrescriptionByIdHandler);
router.put("/prescriptions/:id", updatePrescriptionHandler);
router.delete("/prescriptions/:id", deletePrescriptionHandler);

export default router;
