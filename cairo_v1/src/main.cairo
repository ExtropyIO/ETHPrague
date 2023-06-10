#[contract]
mod SudokuSolver{

    ////////////////////////////////
    // Core Library imports
    ////////////////////////////////
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
    use integer::u32_from_felt252;

    use debug::PrintTrait;

    ////////////////////////////////
    // Internal imports
    ////////////////////////////////
    use cairo_v1::utils::helper;


    const SUDOKU: u32 = 9;

    struct Storage{
        sudoku_storage: LegacyMap::<u32, u32>,
    }

    ////////////////////////////////
    // View Functions 
    ////////////////////////////////

    ////////////////////////////////
    // External Functions
    ////////////////////////////////

    #[external]
    fn verify_sudoku(array_values: Array::<felt252>) -> felt252 {

        let array_span = array_values.span();
        // check if length correct
        let sudoku_lenght = array_span.len(); 

        assert (sudoku_lenght == 81, 'Length incorrect'); 

        // check if array numbers are less than 9
        let array_check = array_values.span();
        check_array(array_check); // need to pass a copy of the array or span

        // resetting the storage
        reset_storage();

        //////////////////////
        // Check Row
        //////////////////////
        let mut counter : u32 = 0;

        let result_row = loop {

            if counter == 9 {
                break true;
            }
            
            // check row
            let result_row_single = verify_row(counter, array_span);

            // resetting the storage
            reset_storage();

            if !result_row_single {
                break false;
            }

            counter += 1;
        };

        assert(result_row, 'Failed Row Check');

        //////////////////////
        // Check Column
        //////////////////////
        let mut counter : u32 = 1;

        let result_column = loop {

            if counter == 10 {
                break true;
            }
            
            // check row
            let result_column_single = verify_column(counter, array_span);

            // resetting the storage
            reset_storage();

            if !result_column_single {
                break false;
            }

            counter += 1;
        };

        assert(result_column, 'Failed Column Check');

        //////////////////////
        // Check Box
        //////////////////////
        let mut box_column : u32 = 0;
        let mut box_row : u32 = 1;

        let _result_box = loop {

            if box_column == 9 {
                break true;
            }
            
            let _result_box_row = loop {

                if box_row == 10 {
                    break true;
                }

                let result_box_single = verify_box(box_row, box_column, array_span);

                if !result_box_single {
                    break false;
                }

                box_row += 3;
                reset_storage();
            };

            if !_result_box_row {
                break false;
            }

            box_column += 3;
            box_row = 1;
        };

        assert(_result_box, 'Failed Box Check');
        
        'Sudoku Correct'
    }

    ////////////////////////////////
    // Internal Functions
    ////////////////////////////////

    // row has to be from 0 - 8
    fn verify_row(row : u32, mut _array_values: Span::<felt252>) -> bool {

        let mut counter = 0;

        let result = loop {

            if counter == 9 {
                break true;
            }

            let formula = SUDOKU * row + counter;
            let arr_value = *_array_values.at(formula);
 
            // check if value has been seen at most once
            if u32_from_felt252(arr_value) == sudoku_storage::read(u32_from_felt252(arr_value) - 1) {
                // if true, we mark it as 0 
                sudoku_storage::write(u32_from_felt252(arr_value) -1, 0);
            } else {
                break false; // value has already been seen once
            }
            counter += 1;
        };
        result
    }

    // column has to be from 1 - 9
    fn verify_column(column: u32, mut _array_values: Span::<felt252>) -> bool {

        let mut counter : u32 = 0;

        let result = loop {

            if counter == 9 {
                break true;
            }

            // we get the position in array
            let formula = SUDOKU * counter + column;

            // get the value
            let arr_value = *_array_values.at(formula - 1);

            // check if value has been seen at most once
            if u32_from_felt252(arr_value) == sudoku_storage::read(u32_from_felt252(arr_value) - 1) {
                // if true, we mark it as 0 
                sudoku_storage::write(u32_from_felt252(arr_value) - 1, 0);
            } else {
                break false; // value has already been seen once
            }
            counter += 1;
        };
        result
    }

    fn verify_box(mut row: u32, mut column: u32, mut _array_values: Span::<felt252>) -> bool {

        let row_max : u32 = row + 3;
        let column_max : u32 = column + 3;

        let result_column = loop {

            if column == column_max {
                break true;
            }

            // column 
            let result_row = loop {

                // rows 
                if row == row_max{
                    break true;
                }

                // we get the position in array
                let formula = SUDOKU * column + row;

                // get the value
                let arr_value = *_array_values.at(formula - 1);

                // check if value has been seen at most once
                if u32_from_felt252(arr_value) == sudoku_storage::read(u32_from_felt252(arr_value) - 1) {
                    // if true, we mark it as 0 
                    sudoku_storage::write(u32_from_felt252(arr_value) - 1, 0);
                } else {
                    break false; // value has already been seen once
                }
                row += 1;
            };

            if !result_row {
                break false;
            }

            column += 1;
            row = row_max - 3; // reseting the row 
        };

        result_column
    }

    fn reset_storage(){
        let mut counter : u32 = 0;
        loop {
            if counter == 9 {
                break ();
            }
            sudoku_storage::write(counter, counter + 1);
            counter += 1;
        };
    }

    fn check_array(mut array_values: Span::<felt252>) {

        loop {

            if array_values.is_empty() {
                break true;
            }

            let value = *array_values.at(0);

            assert(u32_from_felt252(value) < 10, 'Number bigger than 9');

            array_values.pop_front().unwrap();

        };


    }
    
}