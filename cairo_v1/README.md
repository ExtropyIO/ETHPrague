# Sudoku Solution Prover

Proves knowledge of the solution to a given Sudoku puzzle.

<!-- To be described -->

## Utils:

### `helper.py`

The python file helps to create a valid 9x9.

**Outputs**:

`sudoku_cairo.txt` - which can be used in the `test_01.cairo` to check if the contract validates a correct Sudoku.

`sudoku_contract.txt` - which can be used in on the deployed smart contract to validate a correct Sudoku.

`sudoku_unsolved.txt` - the initial unsolved Sudoku in a readable format

`sudoku_solved.txt` - the solved Sudoku in a readable format
