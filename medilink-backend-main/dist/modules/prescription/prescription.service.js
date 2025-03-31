"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deletePrescription = exports.updatePrescription = exports.getPrescriptionById = exports.getPrescriptions = exports.createPrescription = void 0;
const db_1 = __importDefault(require("../../lib/db"));
// Create a new prescription
const createPrescription = async (input) => {
    return db_1.default.prescription.create({
        data: input,
    });
};
exports.createPrescription = createPrescription;
// Get all prescriptions
const getPrescriptions = async () => {
    return db_1.default.prescription.findMany({
        where: { deleteStatus: false },
    });
};
exports.getPrescriptions = getPrescriptions;
// Get a prescription by ID
const getPrescriptionById = async (id) => {
    return db_1.default.prescription.findUnique({
        where: { id, deleteStatus: false },
    });
};
exports.getPrescriptionById = getPrescriptionById;
// Update a prescription
const updatePrescription = async (id, input) => {
    return db_1.default.prescription.update({
        where: { id },
        data: input,
    });
};
exports.updatePrescription = updatePrescription;
// Delete a prescription (soft delete)
const deletePrescription = async (id) => {
    return db_1.default.prescription.update({
        where: { id },
        data: { deleteStatus: true },
    });
};
exports.deletePrescription = deletePrescription;
