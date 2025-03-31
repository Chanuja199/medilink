"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const notification_controller_1 = require("./notification.controller");
const router = express_1.default.Router();
// Notification routes
router.post("/notifications", notification_controller_1.createNotificationHandler);
router.get("/notifications", notification_controller_1.getNotificationsHandler);
router.get("/notifications/:id", notification_controller_1.getNotificationByIdHandler);
router.put("/notifications/:id", notification_controller_1.updateNotificationHandler);
router.delete("/notifications/:id", notification_controller_1.deleteNotificationHandler);
exports.default = router;
