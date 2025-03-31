"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteMedicine = exports.updateMedicine = exports.getMedicineById = exports.getMedicines = exports.createMedicine = void 0;
const db_1 = __importDefault(require("../../lib/db"));
// Create a new medicine
const createMedicine = async (input) => {
    return db_1.default.medicine.create({
        data: input,
    });
};
exports.createMedicine = createMedicine;
// Get all medicines
const getMedicines = async () => {
    return db_1.default.medicine.findMany({
        where: { deleteStatus: false },
    });
};
exports.getMedicines = getMedicines;
// Get a medicine by ID
const getMedicineById = async (id) => {
    return db_1.default.medicine.findUnique({
        where: { id, deleteStatus: false },
    });
};
exports.getMedicineById = getMedicineById;
// Update a medicine
const updateMedicine = async (id, input) => {
    return db_1.default.medicine.update({
        where: { id },
        data: input,
    });
};
exports.updateMedicine = updateMedicine;
// Delete a medicine (soft delete)
const deleteMedicine = async (id) => {
    return db_1.default.medicine.update({
        where: { id },
        data: { deleteStatus: true },
    });
};
exports.deleteMedicine = deleteMedicine;
