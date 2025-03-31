/*
  Warnings:

  - A unique constraint covering the columns `[userId]` on the table `Pharmacy` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `userId` to the `Pharmacy` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Pharmacy" ADD COLUMN     "userId" INTEGER NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "Pharmacy_userId_key" ON "Pharmacy"("userId");

-- AddForeignKey
ALTER TABLE "Pharmacy" ADD CONSTRAINT "Pharmacy_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
