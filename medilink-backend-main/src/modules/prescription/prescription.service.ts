import prisma from "../../lib/db";
import {
  CreatePrescriptionInput,
  UpdatePrescriptionInput,
} from "./prescription.schemas";

// Create a new prescription
export const createPrescription = async (input: CreatePrescriptionInput) => {
  return prisma.prescription.create({
    data: { ...input, userId: parseInt(input.userId) },
  });
};

// Get all prescriptions
export const getPrescriptions = async () => {
  return prisma.prescription.findMany({
    where: { deleteStatus: false },
  });
};

// Get a prescription by ID
export const getPrescriptionById = async (id: number) => {
  return prisma.prescription.findUnique({
    where: { id, deleteStatus: false },
  });
};

// Update a prescription
export const updatePrescription = async (
  id: number,
  input: UpdatePrescriptionInput
) => {
  return prisma.prescription.update({
    where: { id },
    data: input,
  });
};

// Delete a prescription (soft delete)
export const deletePrescription = async (id: number) => {
  return prisma.prescription.update({
    where: { id },
    data: { deleteStatus: true },
  });
};
