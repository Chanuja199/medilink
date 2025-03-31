import { Request, Response } from "express";
import {
  createPharmacy,
  getPharmacies,
  getPharmacyById,
  updatePharmacy,
  deletePharmacy,
} from "./pharmacy.service";
import { CreatePharmacyInput, UpdatePharmacyInput } from "./pharmacy.schemas";

// Create a new pharmacy
export const createPharmacyHandler = async (req: Request, res: Response) => {
  try {
    const data = req.body as CreatePharmacyInput;
    const pharmacy = await createPharmacy(data);
    res.status(201).json(pharmacy);
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};

// Get all pharmacies
export const getPharmaciesHandler = async (req: Request, res: Response) => {
  try {
    const pharmacies = await getPharmacies();
    res.status(200).json(pharmacies);
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};

// Get a pharmacy by ID
export const getPharmacyByIdHandler = async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id, 10);
    const pharmacy = await getPharmacyById(id);
    res.status(200).json(pharmacy);
  } catch (error: any) {
    res.status(404).json({ message: error.message });
  }
};

// Update a pharmacy
export const updatePharmacyHandler = async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id, 10);
    const data = req.body as UpdatePharmacyInput;
    const pharmacy = await updatePharmacy(id, data);
    res.status(200).json(pharmacy);
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};

// Delete a pharmacy (soft delete)
export const deletePharmacyHandler = async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id, 10);
    await deletePharmacy(id);
    res.status(204).send();
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};
