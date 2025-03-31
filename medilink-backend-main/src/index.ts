import express from "express";
import routes from "./routes";
import path from "path";

const app = express();
const port = 5001;

// Middleware
app.use(express.json());
const uploadsPath = path.join(__dirname, "..", "uploads");
app.use("/uploads", express.static(uploadsPath));

// Routes
app.use(routes);

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
