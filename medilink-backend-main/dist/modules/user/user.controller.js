"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.loginUserHandler = exports.deleteUserHandler = exports.updateUserHandler = exports.getUserByIdHandler = exports.getUsersHandler = exports.createUserHandler = void 0;
const user_service_1 = require("./user.service");
// Create a new user
const createUserHandler = async (req, res) => {
    const data = req.body;
    const user = await (0, user_service_1.createUser)(data);
    res.status(201).json(user);
};
exports.createUserHandler = createUserHandler;
// Get all users
const getUsersHandler = async (req, res) => {
    const users = await (0, user_service_1.getUsers)();
    res.status(200).json(users);
};
exports.getUsersHandler = getUsersHandler;
// Get a user by ID
const getUserByIdHandler = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    const user = await (0, user_service_1.getUserById)(id);
    if (!user) {
        return res.status(404).json({ message: "User not found" });
    }
    res.status(200).json(user);
};
exports.getUserByIdHandler = getUserByIdHandler;
// Update a user
const updateUserHandler = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    const data = req.body;
    const user = await (0, user_service_1.updateUser)(id, data);
    res.status(200).json(user);
};
exports.updateUserHandler = updateUserHandler;
// Delete a user (soft delete)
const deleteUserHandler = async (req, res) => {
    const id = parseInt(req.params.id, 10);
    await (0, user_service_1.deleteUser)(id);
    res.status(204).send();
};
exports.deleteUserHandler = deleteUserHandler;
// User login
const loginUserHandler = async (req, res) => {
    const data = req.body;
    const user = await (0, user_service_1.loginUser)(data);
    res.status(200).json(user);
};
exports.loginUserHandler = loginUserHandler;
