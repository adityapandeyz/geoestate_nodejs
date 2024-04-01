/*
  Warnings:

  - You are about to drop the column `billId` on the `Dataset` table. All the data in the column will be lost.
  - You are about to drop the column `datasetName` on the `Dataset` table. All the data in the column will be lost.
  - You are about to drop the column `entryBy` on the `Dataset` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Dataset" DROP COLUMN "billId";
ALTER TABLE "Dataset" DROP COLUMN "datasetName";
ALTER TABLE "Dataset" DROP COLUMN "entryBy";
