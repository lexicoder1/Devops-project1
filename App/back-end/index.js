const express = require("express");
const bodyParser = require("body-parser");
const { Sequelize, DataTypes } = require("sequelize");
const mariadb = require("mariadb");
const dotenv = require("dotenv");

dotenv.config();

const app = express();
const port = 3000;

// Middleware
app.use(bodyParser.json());

// Create MariaDB connection pool
const pool = mariadb.createPool({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "username",
  password: process.env.DB_PASSWORD || "password",
  database: process.env.DB_NAME || "lexi",
  connectionLimit: 5,
});

// Initialize Sequelize
const sequelize = new Sequelize(
  process.env.DB_NAME || "lexi",
  process.env.DB_USER || "username",
  process.env.DB_PASSWORD || "password",
  {
    host: process.env.DB_HOST || "localhost",
    dialect: "mariadb",
  }
);

// Define User Model
const User = sequelize.define(
  "User",
  {
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
    },
  },
  {
    timestamps: true, // Enable timestamps
  }
);

// Sync the database
sequelize
  .sync({ alter: true })
  .then(() => {
    console.log("Database synced.");
  })
  .catch((err) => {
    console.error("Error syncing database:", err);
  });

// Helper function to execute raw SQL queries
async function executeQuery(query, params = []) {
  let connection;
  try {
    connection = await pool.getConnection();
    const results = await connection.query(query, params);
    return results;
  } catch (err) {
    console.error("Database Error:", err);
    throw err;
  } finally {
    if (connection) connection.release();
  }
}

// Routes

// Register User
app.post("/register", async (req, res) => {
  const { email, password } = req.body;

  // if (!email || !password) {
  //   return res.status(400).json({ error: "Email and password are required." });
  // }

  try {
    await executeQuery("INSERT INTO Users (email, password, createdAt,updatedAt) VALUES (?, ?, ?, ?)", [
      email,
      password,
      new Date(),
      new Date()
    ]);
    res.status(201).json({ message: "User registered successfully." });
  } catch (err) {
    if (err.code === "ER_DUP_ENTRY") {
      return res.status(400).json({ error: "Email already exists." });
    }
    console.error(err);
    res.status(500).json({ error: "Error registering user." });
  }
});

// Login User
app.post("/login", async (req, res) => {
  const { email, password } = req.body;

  // if (!email || !password) {
  //   return res.status(400).json({ error: "Email and password are required." });
  // }

  try {
    const users = await executeQuery("SELECT * FROM Users WHERE email = ?", [
      email,
    ]);

    if (users.length === 0) {
      return res.status(404).json({ error: "User not found." });
    }

    const user = users[0];

    // Normally, you'd hash and compare the password here
    if (password !== user.password) {
      return res.status(401).json({ error: "Invalid credentials." });
    }

    // Create a token here if authentication succeeds (placeholder for JWT)
    res.status(200).json({ message: "Login successful." });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error logging in." });
  }
});

// Get All Users
app.get("/users", async (req, res) => {
  try {
    const users = await executeQuery("SELECT id, email FROM Users");
    res.status(200).json(users);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error fetching users." });
  }
});

// Start Server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});