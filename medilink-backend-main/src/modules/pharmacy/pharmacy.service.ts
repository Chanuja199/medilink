import prisma from "../../lib/db";
import { CreatePharmacyInput, UpdatePharmacyInput } from "./pharmacy.schemas";

// Create a new pharmacy
export const createPharmacy = async (input: CreatePharmacyInput) => {
  try {
    return await prisma.pharmacy.create({
      data: input,
    });
  } catch (error) {
    console.error(error);
    throw new Error("Failed to create pharmacy");
  }
};

// Get all pharmacies
export const getPharmacies = async () => {
  try {
    return await prisma.pharmacy.findMany({
      where: { deleteStatus: false },
    });
  } catch (error) {
    throw new Error("Failed to fetch pharmacies");
  }
};

// Get a pharmacy by ID
export const getPharmacyById = async (id: number) => {
  try {
    const pharmacy = await prisma.pharmacy.findUnique({
      where: { id, deleteStatus: false },
    });

    if (!pharmacy) {
      throw new Error("Pharmacy not found");
    }

    return pharmacy;
  } catch (error) {
    throw new Error("Failed to fetch pharmacy");
  }
};

// Update a pharmacy
export const updatePharmacy = async (
  id: number,
  input: UpdatePharmacyInput
) => {
  try {
    return await prisma.pharmacy.update({
      where: { id },
      data: input,
    });
  } catch (error) {
    throw new Error("Failed to update pharmacy");
  }
};

// Delete a pharmacy (soft delete)
export const deletePharmacy = async (id: number) => {
  try {
    return await prisma.pharmacy.update({
      where: { id },
      data: { deleteStatus: true },
    });
  } catch (error) {
    throw new Error("Failed to delete pharmacy");
  }
};
