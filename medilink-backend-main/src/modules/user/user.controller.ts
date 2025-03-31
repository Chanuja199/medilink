// src/modules/user/user.controller.ts
import { Request, Response } from "express";
import {
  createUser,
  getUsers,
  getUserById,
  updateUser,
  deleteUser,
  loginUser,
} from "./user.service";
import {
  CreateUserInput,
  UpdateUserInput,
  LoginUserInput,
} from "./user.schemas";

// Create a new user
export const createUserHandler = async (req: Request, res: Response) => {
  try {
    const data = req.body as CreateUserInput;
    const user = await createUser(data);
    res.status(201).json(user);
  } catch (error) {
    console.error("Error creating user:", error);
    res.status(500).json({
      message: "Failed to create user",
      error: error instanceof Error ? error.message : String(error),
    });
  }
};

// Get all users
export const getUsersHandler = async (req: Request, res: Response) => {
  try {
    const users = await getUsers();
    res.status(200).json(users);
  } catch (error) {
    console.error("Error fetching users:", error);
    res.status(500).json({
      message: "Failed to fetch users",
      error: error instanceof Error ? error.message : String(error),
    });
  }
};

// Get a user by ID
export const getUserByIdHandler = async (
  req: Request,
  res: Response
): Promise<any> => {
  try {
    const id = parseInt(req.params.id, 10);
    const user = await getUserById(id);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.status(200).json(user);
  } catch (error) {
    console.error(`Error fetching user with ID ${req.params.id}:`, error);
    res.status(500).json({
      message: "Failed to fetch user",
      error: error instanceof Error ? error.message : String(error),
    });
  }
};

// Update a user
export const updateUserHandler = async (
  req: Request,
  res: Response
): Promise<any> => {
  try {
    const id = parseInt(req.params.id, 10);
    const data = req.body as UpdateUserInput;
    const user = await updateUser(id, data);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.status(200).json(user);
  } catch (error) {
    console.error(`Error updating user with ID ${req.params.id}:`, error);
    res.status(500).json({
      message: "Failed to update user",
      error: error instanceof Error ? error.message : String(error),
    });
  }
};

// Delete a user (soft delete)
export const deleteUserHandler = async (
  req: Request,
  res: Response
): Promise<any> => {
  try {
    const id = parseInt(req.params.id, 10);
    const result = await deleteUser(id);

    if (!result) {
      return res.status(404).json({ message: "User not found" });
    }

    res.status(204).send();
  } catch (error) {
    console.error(`Error deleting user with ID ${req.params.id}:`, error);
    res.status(500).json({
      message: "Failed to delete user",
      error: error instanceof Error ? error.message : String(error),
    });
  }
};

// User login
export const loginUserHandler = async (
  req: Request,
  res: Response
): Promise<any> => {
  try {
    const data = req.body as LoginUserInput;
    const user = await loginUser(data);

    if (!user) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    res.status(200).json(user);
  } catch (error) {
    console.error("Error during login:", error);
    res.status(500).json({
      message: "Login failed",
      error: error instanceof Error ? error.message : String(error),
    });
  }
};
