import { ethers } from "hardhat";

const CONTRACTS = ["SudokuVerifier"];

async function main() {
  const sudokuVerifier = await ethers.getContractFactory("SudokuVerifier");
  const sudokuVerifierContract = await sudokuVerifier.deploy();
  console.log(`SudokuVerifier deployed to ${sudokuVerifierContract.address}`);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
