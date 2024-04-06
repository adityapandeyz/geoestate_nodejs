const express = require("express");
const auth = require("../middlewares/auth");
const { PrismaClient } = require("@prisma/client");

const datasetRouter = express.Router();
const prisma = new PrismaClient();

datasetRouter.get("/api/datasets", async (req, res) => {
  try {
    const datasets = await prisma.dataset.findMany();
    
    res.status(201).json(datasets);

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

datasetRouter.post("/api/create-dataset", async (req, res) => {
  try {
    const { 
      refNo,
      bankName,
      branchName,
      partyName,
      colonyName,
      cityVillageName,
      latitude,
      longitude,
      marketRate,
      unit,
      createdAt,
      remarks,
      colorMark,
      dateOfVisit,

    } = req.body;

    const existingDataset = await prisma.dataset.findFirst({where: { latitude: latitude },});

    if(existingDataset){
      return res.status(400).json({ msg: "Dataset with the same latitude already exists!" });
    }

    const parsedCreatedAt = new Date(createdAt);
    const parsedDateOfVisit = new Date(dateOfVisit);


    const createdDataset = await prisma.dataset.create({
      data : {
     refNo:   refNo,
       bankName: bankName, 
        branchName: branchName,
        partyName: partyName,
        colonyName: colonyName,
        cityVillageName: cityVillageName,
        latitude: latitude,
        longitude: longitude,
        marketRate: marketRate,
        unit: unit,
        createdAt: parsedCreatedAt,
        remarks: remarks,
        colorMark: colorMark,
        dateOfVisit: parsedDateOfVisit,


      }
    });

    res.status(201).json(createdDataset);

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

datasetRouter.delete("/api/delete-dataset/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const dataset = await prisma.dataset.delete({
      where: {
        id: parseInt(id),
      },
    });

    res.status(201).json(dataset);

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});



module.exports = datasetRouter;
