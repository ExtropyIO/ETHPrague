import { compile } from '@noir-lang/noir_wasm';
import { setup_generic_prover_and_verifier, create_proof, verify_proof } from '@noir-lang/barretenberg/dest/client_proofs';
import path from 'path';
import { expect } from 'chai';
import { ethers } from "hardhat";
import { Contract, ContractFactory, utils } from 'ethers';

describe('Sudoku solidity verifier', function () {
  let Verifier: ContractFactory;
  let verifierContract: Contract;

  before(async () => {
    Verifier = await ethers.getContractFactory("SudokuVerifier");
    verifierContract = await Verifier.deploy();
  });

  it("Should verify correct solution using proof generated by typescript wrapper", async () => {
    const compiled_program = compile(path.resolve(__dirname, '../circuits/sudoku/src/main.nr'));
    let acir = compiled_program.circuit;
    const abi = compiled_program.abi;

    abi.puzzle = [8, 0, 0, 0, 0, 0, 4, 0, 1, 0, 0, 2, 3, 6, 0, 0, 8, 0, 0, 0, 5, 0, 0, 9, 0, 0, 0, 9, 5, 0, 0, 4, 8, 0, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, 0, 0, 4, 0, 0, 1, 0, 6, 0, 0, 0, 0, 0, 8, 0, 7, 0, 0, 6, 7, 0, 0, 0, 0, 0, 9, 3, 2, 3, 1, 6, 2, 0, 0, 0, 0, 0];
    abi.solution = [8, 9, 3, 7, 2, 5, 4, 6, 1, 4, 7, 2, 3, 6, 1, 5, 8, 9, 1, 6, 5, 4, 8, 9, 3, 2, 7, 9, 5, 7, 6, 4, 8, 2, 1, 3, 6, 3, 1, 5, 7, 2, 8, 9, 4, 2, 4, 8, 9, 1, 3, 6, 7, 5, 5, 2, 9, 8, 3, 7, 1, 4, 6, 7, 8, 4, 1, 5, 6, 9, 3, 2, 3, 1, 6, 2, 9, 4, 7, 5, 8];

    let [prover, verifier] = await setup_generic_prover_and_verifier(acir);

    const proof = await create_proof(prover, acir, abi);

    const verified = await verify_proof(verifier, proof);
    expect(verified).eq(true)

    const sc_verified = await verifierContract.verify(proof);
    expect(sc_verified).eq(true)
  });

  it("Should fail on incorrect solution using proof generated by typescript wrapper", async () => {
    const compiled_program = compile(path.resolve(__dirname, '../circuits/sudoku/src/main.nr'));
    let acir = compiled_program.circuit;
    const abi = compiled_program.abi;

    abi.puzzle = [8, 0, 0, 0, 0, 0, 4, 0, 1, 0, 0, 2, 3, 6, 0, 0, 8, 0, 0, 0, 5, 0, 0, 9, 0, 0, 0, 9, 5, 0, 0, 4, 8, 0, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, 0, 0, 4, 0, 0, 1, 0, 6, 0, 0, 0, 0, 0, 8, 0, 7, 0, 0, 6, 7, 0, 0, 0, 0, 0, 9, 3, 2, 3, 1, 6, 2, 0, 0, 0, 0, 0];
    abi.solution = [8, 9, 3, 2, 7, 5, 4, 6, 1, 4, 7, 2, 3, 6, 1, 5, 8, 9, 1, 6, 5, 4, 8, 9, 3, 2, 7, 9, 5, 7, 6, 4, 8, 2, 1, 3, 6, 3, 1, 5, 7, 2, 8, 9, 4, 2, 4, 8, 9, 1, 3, 6, 7, 5, 5, 2, 9, 8, 3, 7, 1, 4, 6, 7, 8, 4, 1, 5, 6, 9, 3, 2, 3, 1, 6, 2, 9, 4, 7, 5, 8];

    let [prover, verifier] = await setup_generic_prover_and_verifier(acir);

    const proof = await create_proof(prover, acir, abi);

    const verified = await verify_proof(verifier, proof);
    expect(verified).eq(false);

    await expect(verifierContract.verify(proof)).to.be.revertedWith('Proof failed');
  });

  it("Should fail on solution that doesn't match puzzle using proof generated by typescript wrapper", async () => {
    const compiled_program = compile(path.resolve(__dirname, '../circuits/sudoku/src/main.nr'));
    let acir = compiled_program.circuit;
    const abi = compiled_program.abi;

    abi.puzzle = [8, 0, 0, 0, 0, 0, 4, 0, 1, 0, 0, 2, 3, 6, 0, 0, 8, 0, 0, 0, 5, 0, 0, 9, 0, 0, 0, 9, 5, 0, 0, 4, 8, 0, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, 0, 0, 4, 0, 0, 1, 0, 6, 0, 0, 0, 0, 0, 8, 0, 7, 0, 0, 6, 7, 0, 0, 0, 0, 0, 9, 3, 2, 3, 1, 6, 2, 0, 0, 0, 0, 0];
    abi.solution = [9, 8, 5, 6, 2, 3, 4, 7, 1, 1, 7, 4, 8, 5, 9, 3, 2, 6, 6, 3, 2, 1, 4, 7, 8, 9, 5, 7, 6, 3, 5, 9, 1, 2, 8, 4, 8, 2, 1, 7, 3, 4, 5, 6, 9, 4, 5, 9, 2, 8, 6, 7, 1, 3, 3, 4, 8, 9, 1, 2, 6, 5, 7, 5, 9, 7, 3, 6, 8, 1, 4, 2, 2, 1, 6, 4, 7, 5, 9, 3, 8];

    let [prover, verifier] = await setup_generic_prover_and_verifier(acir);

    const proof = await create_proof(prover, acir, abi);

    const verified = await verify_proof(verifier, proof);
    expect(verified).eq(false);

    await expect(verifierContract.verify(proof)).to.be.revertedWith('Proof failed');
  });
});