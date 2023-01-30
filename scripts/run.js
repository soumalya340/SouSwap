const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
  const accounts = await ethers.getSigners();
  const DexFactory = await hre.ethers.getContractFactory("SouSwap");
  const Dex = await DexFactory.deploy();
  await Dex.deployed();
  console.log(`The Dex is  deployed to ${Dex.address}`);
  console.log(` the value is ${await Dex.getInputPrice(1, 10, 10)}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
