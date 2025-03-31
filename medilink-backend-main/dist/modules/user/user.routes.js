"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// src/modules/user/user.routes.ts
const express_1 = __importDefault(require("express"));
const user_controller_1 = require("./user.controller");
const router = express_1.default.Router();
// User routes
router.post("/users", user_controller_1.createUserHandler);
router.get("/users", user_controller_1.getUsersHandler);
router.get("/users/:id", user_controller_1.getUserByIdHandler);
router.put("/users/:id", user_controller_1.updateUserHandler);
router.delete("/users/:id", user_controller_1.deleteUserHandler);
router.post("/users/login", user_controller_1.loginUserHandler);
exports.default = router;
