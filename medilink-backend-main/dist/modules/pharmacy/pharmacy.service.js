"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deletePharmacy = exports.updatePharmacy = exports.getPharmacyById = exports.getPharmacies = exports.createPharmacy = void 0;
const db_1 = __importDefault(require("../../lib/db"));
// Create a new pharmacy
const createPharmacy = async (input) => {
    try {
        return await db_1.default.pharmacy.create({
            data: input,
        });
    }
    catch (error) {
        throw new Error("Failed to create pharmacy");
    }
};
exports.createPharmacy = createPharmacy;
// Get all pharmacies
const getPharmacies = async () => {
    try {
        return await db_1.default.pharmacy.findMany({
            where: { deleteStatus: false },
        });
    }
    catch (error) {
        throw new Error("Failed to fetch pharmacies");
    }
};
exports.getPharmacies = getPharmacies;
// Get a pharmacy by ID
const getPharmacyById = async (id) => {
    try {
        const pharmacy = await db_1.default.pharmacy.findUnique({
            where: { id, deleteStatus: false },
        });
        if (!pharmacy) {
            throw new Error("Pharmacy not found");
        }
        return pharmacy;
    }
    catch (error) {
        throw new Error("Failed to fetch pharmacy");
    }
};
exports.getPharmacyById = getPharmacyById;
// Update a pharmacy
const updatePharmacy = async (id, input) => {
    try {
        return await db_1.default.pharmacy.update({
            where: { id },
            data: input,
        });
    }
    catch (error) {
        throw new Error("Failed to update pharmacy");
    }
};
exports.updatePharmacy = updatePharmacy;
// Delete a pharmacy (soft delete)
const deletePharmacy = async (id) => {
    try {
        return await db_1.default.pharmacy.update({
            where: { id },
            data: { deleteStatus: true },
        });
    }
    catch (error) {
        throw new Error("Failed to delete pharmacy");
    }
};
exports.deletePharmacy = deletePharmacy;
