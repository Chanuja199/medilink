// src/modules/user/user.routes.ts
import express from "express";
import {
  createUserHandler,
  getUsersHandler,
  getUserByIdHandler,
  updateUserHandler,
  deleteUserHandler,
  loginUserHandler,
} from "./user.controller";

const router = express.Router();

// User routes
router.post("/users", createUserHandler);
router.get("/users", getUsersHandler);
router.get("/users/:id", getUserByIdHandler);
router.put("/users/:id", updateUserHandler);
router.delete("/users/:id", deleteUserHandler);
router.post("/users/login", loginUserHandler);

export default router;
