
use cairo_v1::main::SudokuSolver;

use starknet::ContractAddress;
use starknet::get_caller_address;
use starknet::get_contract_address;
use starknet::info::get_block_timestamp;

use traits::TryInto;
use traits::Into;
use option::OptionTrait;
use array::ArrayTrait;
use array::SpanTrait;

use integer::u256;
use integer::u256_from_felt252;

use debug::PrintTrait;

#[test]
#[available_gas(200000000)]
fn run_correct_sudoku() {
    let sudoku_array = create_array();
    // correct sudoku
    SudokuSolver::verify_sudoku(sudoku_array);
}

#[test]
#[available_gas(200000000)]
#[should_panic(expected:('Length incorrect', ))]
fn run_wrong_length() {
    // create a span
    let mut sudoku_array = create_array();
    sudoku_array.pop_front().unwrap();

    SudokuSolver::verify_sudoku(sudoku_array);
}

#[test]
#[available_gas(200000000)]
#[should_panic(expected:('Number bigger than 9', ))]
fn run_wrong_number() {
    // create a span
    let mut sudoku_array = create_array();
    sudoku_array.pop_front().unwrap();

    // add wrong value
    sudoku_array.append(22);

    SudokuSolver::verify_sudoku(sudoku_array);
}

#[test]
#[available_gas(200000000)]
#[should_panic(expected:('Failed Row Check', ))]
fn run_wrong_sudoku_row() {
    // create a span
    let mut sudoku_array = create_array();
    sudoku_array.pop_front().unwrap();

    // add wrong value
    sudoku_array.append(2);

    SudokuSolver::verify_sudoku(sudoku_array);
}

#[test]
#[available_gas(200000000)]
#[should_panic(expected:('Failed Row Check', ))]
fn run_wrong_sudoku_() {
    // create a span
    let mut sudoku_array = create_array();
    sudoku_array.pop_front().unwrap();

    // add wrong value
    sudoku_array.append(2);

    SudokuSolver::verify_sudoku(sudoku_array);
}

fn create_array() -> Array<felt252> {

    let mut arr = ArrayTrait::new();
    
    arr.append(3);
    arr.append(1);
    arr.append(7);
    arr.append(4);
    arr.append(9);
    arr.append(8);
    arr.append(2);
    arr.append(6);
    arr.append(5);
    arr.append(2);
    arr.append(8);
    arr.append(9);
    arr.append(1);
    arr.append(6);
    arr.append(5);
    arr.append(3);
    arr.append(4);
    arr.append(7);
    arr.append(4);
    arr.append(6);
    arr.append(5);
    arr.append(3);
    arr.append(2);
    arr.append(7);
    arr.append(1);
    arr.append(9);
    arr.append(8);
    arr.append(1);
    arr.append(2);
    arr.append(4);
    arr.append(6);
    arr.append(8);
    arr.append(9);
    arr.append(5);
    arr.append(7);
    arr.append(3);
    arr.append(9);
    arr.append(5);
    arr.append(8);
    arr.append(7);
    arr.append(3);
    arr.append(4);
    arr.append(6);
    arr.append(1);
    arr.append(2);
    arr.append(6);
    arr.append(7);
    arr.append(3);
    arr.append(2);
    arr.append(5);
    arr.append(1);
    arr.append(9);
    arr.append(8);
    arr.append(4);
    arr.append(5);
    arr.append(4);
    arr.append(1);
    arr.append(9);
    arr.append(7);
    arr.append(2);
    arr.append(8);
    arr.append(3);
    arr.append(6);
    arr.append(8);
    arr.append(9);
    arr.append(6);
    arr.append(5);
    arr.append(4);
    arr.append(3);
    arr.append(7);
    arr.append(2);
    arr.append(1);
    arr.append(7);
    arr.append(3);
    arr.append(2);
    arr.append(8);
    arr.append(1);
    arr.append(6);
    arr.append(4);
    arr.append(5);
    arr.append(9);

    arr   
} 