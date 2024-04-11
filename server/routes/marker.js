const express = require("express");
const auth = require("../middlewares/auth");
const { PrismaClient } = require("@prisma/client");

const markerRouter = express.Router();
const prisma = new PrismaClient();

markerRouter.get("/api/markers", async (req, res) => {
  try {
    const markers = await prisma.marker.findMany();

    res.status(201).json(markers);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

markerRouter.post("/api/create-marker", async (req, res) => {
  try {
    const { latitude, longitude, createdAt } =
      req.body;

    const existingMarker = await prisma.marker.findFirst({
      where: { latitude: latitude },
    });

    if (existingMarker) {
      return res
        .status(400)
        .json({ msg: "Marker with same latitude already exists!" });
    }

    const parsedCreatedAt = new Date(createdAt);


    const createdMarkers = await prisma.marker.create({
      data: {
        latitude: latitude,
        longitude: longitude,
        marketRate: 0,
        unit: 'SQFT',
        color: 'red',
        createdAt: parsedCreatedAt,
      },
    });

    res.status(201).json(createdMarkers);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

markerRouter.delete("/api/delete-marker/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const deletedMarker = await prisma.marker.delete({
      where: {
        id: parseInt(id),
      },
    });

    res.status(201).json(deletedMarker);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

markerRouter.put("/api/update-rate-marker", async (req, res) => {
  try {
    const { id, marketRate, unit } = req.body;


   const updatedMarker = await prisma.marker.update({
      where: {
        id: parseInt(id),
      },
      data: {
        marketRate: marketRate,
        unit: unit,
      },
    
  });

    res.status(201).json(updatedMarker);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

markerRouter.put("/api/update-color-marker", async (req, res) => {
  try {
    const { id, color } = req.body;

    const updatedMarker = await prisma.marker.update({
      where: {
        id: parseInt(id),
      },
      data: {
        color: color,
      },
    });

    res.status(201).json(updatedMarker);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}
);

module.exports = markerRouter;
