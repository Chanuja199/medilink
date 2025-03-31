import { Request, Response } from "express";
import {
  createPrescription,
  getPrescriptions,
  getPrescriptionById,
  updatePrescription,
  deletePrescription,
} from "./prescription.service";
import {
  CreatePrescriptionInput,
  UpdatePrescriptionInput,
} from "./prescription.schemas";
import multer from "multer";
import path from "path";

// Multer configuration for file upload
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});
export const upload = multer({ storage });

// Create a new prescription
export const createPrescriptionHandler = async (
  req: Request,
  res: Response
) => {
  try {
    const data = req.body as CreatePrescriptionInput;
    const imageUrl = req.file ? `/uploads/${req.file.filename}` : undefined;
    const prescription = await createPrescription({ ...data, imageUrl });
    res.status(201).json(prescription);
  } catch (error) {
    console.error("Error creating prescription:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// Get all prescriptions
export const getPrescriptionsHandler = async (req: Request, res: Response) => {
  try {
    const prescriptions = await getPrescriptions();
    res.status(200).json(prescriptions);
  } catch (error) {
    console.error("Error fetching prescriptions:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// Get a prescription by ID
export const getPrescriptionByIdHandler = async (
  req: Request,
  res: Response
): Promise<any> => {
  try {
    const id = parseInt(req.params.id, 10);
    const prescription = await getPrescriptionById(id);

    if (!prescription) {
      return res.status(404).json({ message: "Prescription not found" });
    }

    res.status(200).json(prescription);
  } catch (error) {
    console.error("Error fetching prescription by ID:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// Update a prescription
export const updatePrescriptionHandler = async (
  req: Request,
  res: Response
) => {
  try {
    const id = parseInt(req.params.id, 10);
    const data = req.body as UpdatePrescriptionInput;
    const prescription = await updatePrescription(id, data);
    res.status(200).json(prescription);
  } catch (error) {
    console.error("Error updating prescription:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// Delete a prescription (soft delete)
export const deletePrescriptionHandler = async (
  req: Request,
  res: Response
) => {
  try {
    const id = parseInt(req.params.id, 10);
    await deletePrescription(id);
    res.status(204).send();
  } catch (error) {
    console.error("Error deleting prescription:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};
