"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deletePrescriptionHandler = exports.updatePrescriptionHandler = exports.getPrescriptionByIdHandler = exports.getPrescriptionsHandler = exports.createPrescriptionHandler = void 0;
const prescription_service_1 = require("./prescription.service");
// Create a new prescription
const createPrescriptionHandler = async (req, res) => {
    const data = req.body;
    const prescription = await (0, prescription_service_1.createPrescription)(data);
    res.status(201).json(prescription);
};
exports.createPrescriptionHandler = createPrescriptionHandler;
// Get all prescriptions
const getPrescriptionsHandler = async (req, res) => {
    const prescriptions = await (0, prescription_service_1.getPrescriptions)();
    res.status(200).json(prescriptions);
};
exports.getPrescriptionsHandler = getPrescriptionsHandler;
// Get a prescription by ID
const getPrescriptionByIdHandler = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    const prescription = await (0, prescription_service_1.getPrescriptionById)(id);
    if (!prescription) {
        return res.status(404).json({ message: "Prescription not found" });
    }
    res.status(200).json(prescription);
};
exports.getPrescriptionByIdHandler = getPrescriptionByIdHandler;
// Update a prescription
const updatePrescriptionHandler = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    const data = req.body;
    const prescription = await (0, prescription_service_1.updatePrescription)(id, data);
    res.status(200).json(prescription);
};
exports.updatePrescriptionHandler = updatePrescriptionHandler;
// Delete a prescription (soft delete)
const deletePrescriptionHandler = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    await (0, prescription_service_1.deletePrescription)(id);
    res.status(204).send();
};
exports.deletePrescriptionHandler = deletePrescriptionHandler;
