"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const medicine_controller_1 = require("./medicine.controller");
const router = express_1.default.Router();
// Medicine routes
router.post("/medicines", medicine_controller_1.createMedicineHandler);
router.get("/medicines", medicine_controller_1.getMedicinesHandler);
router.get("/medicines/:id", medicine_controller_1.getMedicineByIdHandler);
router.put("/medicines/:id", medicine_controller_1.updateMedicineHandler);
router.delete("/medicines/:id", medicine_controller_1.deleteMedicineHandler);
exports.default = router;
