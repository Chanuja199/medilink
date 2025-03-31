"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteMedicineHandler = exports.updateMedicineHandler = exports.getMedicineByIdHandler = exports.getMedicinesHandler = exports.createMedicineHandler = void 0;
const medicine_service_1 = require("./medicine.service");
// Create a new medicine
const createMedicineHandler = async (req, res) => {
    const data = req.body;
    const medicine = await (0, medicine_service_1.createMedicine)(data);
    res.status(201).json(medicine);
};
exports.createMedicineHandler = createMedicineHandler;
// Get all medicines
const getMedicinesHandler = async (req, res) => {
    const medicines = await (0, medicine_service_1.getMedicines)();
    res.status(200).json(medicines);
};
exports.getMedicinesHandler = getMedicinesHandler;
// Get a medicine by ID
const getMedicineByIdHandler = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    const medicine = await (0, medicine_service_1.getMedicineById)(id);
    if (!medicine) {
        return res.status(404).json({ message: "Medicine not found" });
    }
    res.status(200).json(medicine);
};
exports.getMedicineByIdHandler = getMedicineByIdHandler;
// Update a medicine
const updateMedicineHandler = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    const data = req.body;
    const medicine = await (0, medicine_service_1.updateMedicine)(id, data);
    res.status(200).json(medicine);
};
exports.updateMedicineHandler = updateMedicineHandler;
// Delete a medicine (soft delete)
const deleteMedicineHandler = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    await (0, medicine_service_1.deleteMedicine)(id);
    res.status(204).send();
};
exports.deleteMedicineHandler = deleteMedicineHandler;
