import express from "express";
import {
  createMedicineHandler,
  getMedicinesHandler,
  getMedicineByIdHandler,
  updateMedicineHandler,
  deleteMedicineHandler,
} from "./medicine.controller";

const router = express.Router();

// Medicine routes
router.post("/medicines", createMedicineHandler);
router.get("/medicines", getMedicinesHandler);
router.get("/medicines/:id", getMedicineByIdHandler);
router.put("/medicines/:id", updateMedicineHandler);
router.delete("/medicines/:id", deleteMedicineHandler);

export default router;
