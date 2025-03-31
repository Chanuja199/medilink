import express from "express";
import {
  createPharmacyHandler,
  getPharmaciesHandler,
  getPharmacyByIdHandler,
  updatePharmacyHandler,
  deletePharmacyHandler,
} from "./pharmacy.controller";

const router = express.Router();

// Pharmacy routes
router.post("/pharmacies", createPharmacyHandler);
router.get("/pharmacies", getPharmaciesHandler);
router.get("/pharmacies/:id", getPharmacyByIdHandler);
router.put("/pharmacies/:id", updatePharmacyHandler);
router.delete("/pharmacies/:id", deletePharmacyHandler);

export default router;
