"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.loginUser = exports.deleteUser = exports.updateUser = exports.getUserById = exports.getUsers = exports.createUser = void 0;
const db_1 = __importDefault(require("../../lib/db"));
// Create a new user
const createUser = async (input) => {
    return db_1.default.user.create({
        data: input,
    });
};
exports.createUser = createUser;
// Get all users
const getUsers = async () => {
    return db_1.default.user.findMany({
        where: { deleteStatus: false },
    });
};
exports.getUsers = getUsers;
// Get a user by ID
const getUserById = async (id) => {
    return db_1.default.user.findUnique({
        where: { id, deleteStatus: false },
    });
};
exports.getUserById = getUserById;
// Update a user
const updateUser = async (id, input) => {
    return db_1.default.user.update({
        where: { id },
        data: input,
    });
};
exports.updateUser = updateUser;
// Delete a user (soft delete)
const deleteUser = async (id) => {
    return db_1.default.user.update({
        where: { id },
        data: { deleteStatus: true },
    });
};
exports.deleteUser = deleteUser;
// User login
const loginUser = async (input) => {
    const user = await db_1.default.user.findUnique({
        where: { email: input.email, deleteStatus: false },
    });
    if (!user || user.password !== input.password) {
        throw new Error("Invalid email or password");
    }
    return user;
};
exports.loginUser = loginUser;
