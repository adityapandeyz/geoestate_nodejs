const express = require("express");
const auth = require("../middlewares/auth");
const { PrismaClient } = require("@prisma/client");


const bankRouter = express.Router();
const prisma = new PrismaClient();


bankRouter.get("/api/banks/", auth, async (req, res) => {
  try {
    const banks = await prisma.banks;
    res.status(201).json(banks);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = bankRouter;

