import { Request, Response } from "express";
import {
  createMedicine,
  getMedicines,
  getMedicineById,
  updateMedicine,
  deleteMedicine,
} from "./medicine.service";
import { CreateMedicineInput, UpdateMedicineInput } from "./medicine.schemas";

// Create a new medicine
export const createMedicineHandler = async (req: Request, res: Response) => {
  try {
    const data = req.body as CreateMedicineInput;
    const medicine = await createMedicine(data);
    res.status(201).json(medicine);
  } catch (error) {
    console.error("Error creating medicine:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// Get all medicines
export const getMedicinesHandler = async (req: Request, res: Response) => {
  try {
    const medicines = await getMedicines();
    res.status(200).json(medicines);
  } catch (error) {
    console.error("Error fetching medicines:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// Get a medicine by ID
export const getMedicineByIdHandler = async (
  req: Request,
  res: Response
): Promise<any> => {
  try {
    const id = parseInt(req.params.id, 10);
    const medicine = await getMedicineById(id);

    if (!medicine) {
      return res.status(404).json({ message: "Medicine not found" });
    }

    res.status(200).json(medicine);
  } catch (error) {
    console.error("Error fetching medicine by ID:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// Update a medicine
export const updateMedicineHandler = async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id, 10);
    const data = req.body as UpdateMedicineInput;
    const medicine = await updateMedicine(id, data);
    res.status(200).json(medicine);
  } catch (error) {
    console.error("Error updating medicine:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// Delete a medicine (soft delete)
export const deleteMedicineHandler = async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id, 10);
    await deleteMedicine(id);
    res.status(204).send();
  } catch (error) {
    console.error("Error deleting medicine:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};
