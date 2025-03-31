"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const prescription_controller_1 = require("./prescription.controller");
const router = express_1.default.Router();
// Prescription routes
router.post("/prescriptions", prescription_controller_1.createPrescriptionHandler);
router.get("/prescriptions", prescription_controller_1.getPrescriptionsHandler);
router.get("/prescriptions/:id", prescription_controller_1.getPrescriptionByIdHandler);
router.put("/prescriptions/:id", prescription_controller_1.updatePrescriptionHandler);
router.delete("/prescriptions/:id", prescription_controller_1.deletePrescriptionHandler);
exports.default = router;
