"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const pharmacy_controller_1 = require("./pharmacy.controller");
const router = express_1.default.Router();
// Pharmacy routes
router.post("/pharmacies", pharmacy_controller_1.createPharmacyHandler);
router.get("/pharmacies", pharmacy_controller_1.getPharmaciesHandler);
router.get("/pharmacies/:id", pharmacy_controller_1.getPharmacyByIdHandler);
router.put("/pharmacies/:id", pharmacy_controller_1.updatePharmacyHandler);
router.delete("/pharmacies/:id", pharmacy_controller_1.deletePharmacyHandler);
exports.default = router;
