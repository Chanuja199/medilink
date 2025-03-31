"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deletePharmacyHandler = exports.updatePharmacyHandler = exports.getPharmacyByIdHandler = exports.getPharmaciesHandler = exports.createPharmacyHandler = void 0;
const pharmacy_service_1 = require("./pharmacy.service");
// Create a new pharmacy
const createPharmacyHandler = async (req, res) => {
    try {
        const data = req.body;
        const pharmacy = await (0, pharmacy_service_1.createPharmacy)(data);
        res.status(201).json(pharmacy);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
};
exports.createPharmacyHandler = createPharmacyHandler;
// Get all pharmacies
const getPharmaciesHandler = async (req, res) => {
    try {
        const pharmacies = await (0, pharmacy_service_1.getPharmacies)();
        res.status(200).json(pharmacies);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
};
exports.getPharmaciesHandler = getPharmaciesHandler;
// Get a pharmacy by ID
const getPharmacyByIdHandler = async (req, res) => {
    try {
        const id = parseInt(req.params.id, 10);
        const pharmacy = await (0, pharmacy_service_1.getPharmacyById)(id);
        res.status(200).json(pharmacy);
    }
    catch (error) {
        res.status(404).json({ message: error.message });
    }
};
exports.getPharmacyByIdHandler = getPharmacyByIdHandler;
// Update a pharmacy
const updatePharmacyHandler = async (req, res) => {
    try {
        const id = parseInt(req.params.id, 10);
        const data = req.body;
        const pharmacy = await (0, pharmacy_service_1.updatePharmacy)(id, data);
        res.status(200).json(pharmacy);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
};
exports.updatePharmacyHandler = updatePharmacyHandler;
// Delete a pharmacy (soft delete)
const deletePharmacyHandler = async (req, res) => {
    try {
        const id = parseInt(req.params.id, 10);
        await (0, pharmacy_service_1.deletePharmacy)(id);
        res.status(204).send();
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
};
exports.deletePharmacyHandler = deletePharmacyHandler;
