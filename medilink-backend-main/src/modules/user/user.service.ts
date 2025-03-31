import prisma from "../../lib/db";
import {
  CreateUserInput,
  UpdateUserInput,
  LoginUserInput,
} from "./user.schemas";

// Create a new user
export const createUser = async (input: CreateUserInput) => {
  return prisma.user.create({
    data: input,
  });
};

// Get all users
export const getUsers = async () => {
  return prisma.user.findMany({
    where: { deleteStatus: false },
  });
};

// Get a user by ID
export const getUserById = async (id: number) => {
  return prisma.user.findUnique({
    where: { id, deleteStatus: false },
  });
};

// Update a user
export const updateUser = async (id: number, input: UpdateUserInput) => {
  // Remove password field if it exists in the input
  const { password, ...filteredInput } = input;

  return prisma.user.update({
    where: { id },
    data: filteredInput, // Use filtered input without password
  });
};

// Delete a user (soft delete)
export const deleteUser = async (id: number) => {
  return prisma.user.update({
    where: { id },
    data: { deleteStatus: true },
  });
};

// User login
export const loginUser = async (input: LoginUserInput) => {
  const user = await prisma.user.findUnique({
    where: { email: input.email, deleteStatus: false },
  });
  console.log(JSON.stringify(user));
  if (!user || user.password !== input.password) {
    throw new Error("Invalid email or password");
  }

  return user;
};
