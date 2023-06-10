# Sudoku Solution Prover

Proves knowledge of the solution to a given Sudoku puzzle.

| Name          | Transaction Hash                                                                                                                                                       | Contract Address                                                                                                                                                               |
| ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Sudoku Solver | [0x6f2b49aa445ed7ffb199c4f5d910db0f9c76327fcd9088636f892c8dbb12f18](https://testnet.starkscan.co/tx/0x6f2b49aa445ed7ffb199c4f5d910db0f9c76327fcd9088636f892c8dbb12f18) | [0x04c80dc7a9c01c8bdd1444cc4ddad828b997d2059ddd0a57c558946e1550ba7e](https://testnet.starkscan.co/contract/0x04c80dc7a9c01c8bdd1444cc4ddad828b997d2059ddd0a57c558946e1550ba7e) |

1. To start, we generate a unsolved 9x9 Sudoku by using the `utils.py`. Once generated, we will receive an output called `sudoku_unsolved.txt` in `src/output/` folder. Now all we have to do is access that file and start solving the Sudoku!

```
0 0 0  | 0 5 0  | 2 0 0
0 0 3  | 0 0 4  | 0 0 0
2 0 4  | 0 7 0  | 0 5 0
-----------------------
0 0 0  | 0 0 2  | 0 0 0
5 0 0  | 0 0 9  | 0 0 1
0 4 0  | 7 0 0  | 0 0 2
-----------------------
0 1 0  | 0 2 0  | 4 0 0
0 0 0  | 4 0 0  | 0 0 0
0 0 7  | 0 1 0  | 0 0 0
```

2. Here is the solved Sudoku:

```
1 6 8  | 9 5 3  | 2 4 7
7 5 3  | 2 6 4  | 1 8 9
2 9 4  | 1 7 8  | 3 5 6
-----------------------
6 3 1  | 5 8 2  | 7 9 4
5 7 2  | 6 4 9  | 8 3 1
8 4 9  | 7 3 1  | 5 6 2
-----------------------
9 1 6  | 8 2 5  | 4 7 3
3 2 5  | 4 9 7  | 6 1 8
4 8 7  | 3 1 6  | 9 2 5

```

3. After that, we need to convert the Sudoku to a readable format for our contract. This format is an array of 81 elements and each element is separate by a `,`. There is a function in the `utils.py` that converts this and outputs it to a correct format. Once you have the array ready you can use the contract to verify the Sudoku. Use the `verify_sudoku` functions, add the array and confirm your transaction.

```
1, 6, 8, 9, 5, 3, 2, 4, 7,
7, 5, 3, 2, 6, 4, 1, 8, 9,
2, 9, 4, 1, 7, 8, 3, 5, 6,
6, 3, 1, 5, 8, 2, 7, 9, 4,
5, 7, 2, 6, 4, 9, 8, 3, 1,
8, 4, 9, 7, 3, 1, 5, 6, 2,
9, 1, 6, 8, 2, 5, 4, 7, 3,
3, 2, 5, 4, 9, 7, 6, 1, 8,
4, 8, 7, 3, 1, 6, 9, 2, 5
```

Here is the confirmed transaction of the solved Sudoku:

https://testnet.starkscan.co/tx/0x75817bfe90b1fd40378af467274b422de17aac5ea2dfccd75466b0f7c7a9e35

## Utils:

### `helper.py`

The python file helps to create a solved 9x9.

### Felt convertor

To convert `felts` to a readable format, you can use the following converter.

https://stark-utils.vercel.app/converter

**Outputs**:

`sudoku_cairo.txt` - which can be used in the `test_01.cairo` to check if the contract validates a correct Sudoku.

`sudoku_contract.txt` - which can be used in on the deployed smart contract to validate a correct Sudoku.

`sudoku_unsolved.txt` - the initial unsolved Sudoku in a readable format

`sudoku_solved.txt` - the solved Sudoku in a readable format
