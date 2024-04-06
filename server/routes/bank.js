const express = require("express");
const auth = require("../middlewares/auth");
const { PrismaClient } = require("@prisma/client");


const bankRouter = express.Router();
const prisma = new PrismaClient();


bankRouter.get("/api/banks", async (req, res) => {
  try {
    const banks = await prisma.bank.findMany();

    res.status(201).json(banks);

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


bankRouter.post("/api/create-bank", async (req, res) => { 
  try {
    const { 
      bankName,
      branchName,
      ifscCode,
    } = req.body;

    const existingBank = await prisma.bank.findFirst({where: { ifscCode: ifscCode },});

    if(existingBank){
      return res.status(400).json({ msg: "Bank with the same IFSC Code already exists!" });
    }

    const createdBank = await prisma.bank.create({
      data : {
        bankName,
        branchName,
        ifscCode,
       
      }
    });

    res.status(201).json(createdBank);

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

bankRouter.delete("/api/delete-bank/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const bank = await prisma.bank.delete({
      where: {
        id: parseInt(id),
      },
    });

    res.status(201).json(bank);

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = bankRouter;

