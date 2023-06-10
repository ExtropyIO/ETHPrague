import random
import copy
import sys

def generate_sudoku():
    base  = 3
    side  = base*base
    nums  = list(range(1, base*base + 1))
    board = [[None]*side for _ in range(side)]

    def pattern(r, c): 
        return (base*(r%base) + r//base + c) % side

    def shuffle(s): 
        return random.sample(s, len(s)) 

    rBase = range(base) 
    rows  = [ g*base + r for g in shuffle(rBase) for r in shuffle(rBase) ] 
    cols  = [ g*base + c for g in shuffle(rBase) for c in shuffle(rBase) ]
    nums  = shuffle(nums)

    for r in range(side):
        for c in range(side):
            board[r][c] = nums[pattern(r, c)]

    squares = side*side
    empties = squares * 3//4
    for _ in range(empties):
        r, c = random.randrange(side), random.randrange(side)
        while board[r][c] == 0:
            r, c = random.randrange(side), random.randrange(side)
        board[r][c] = 0

    return board

def print_board(board, filename):
        # Create a file object for writing
    with open(filename, 'w') as f:
        # Redirect the standard output to the file
        sys.stdout = f
        for i in range(len(board)):
            if i % 3 == 0 and i != 0:
                print("---------------------")
            for j in range(len(board[0])):
                if j % 3 == 0 and j != 0:
                    print(" | ", end="")
                if j == 8:
                    print(board[i][j])
                else:
                    print(str(board[i][j]) + " ", end="")
                  
        # Restore the standard output
        sys.stdout = sys.__stdout__

def solve(board):
    find = find_empty(board)
    if not find:
        return True
    else:
        row, col = find
    for i in range(1, 10):
        if valid(board, i, (row, col)):
            board[row][col] = i
            if solve(board):
                return True
            board[row][col] = 0
    return False

def valid(board, num, pos):
    for i in range(len(board[0])):
        if board[pos[0]][i] == num and pos[1] != i:
            return False
    for i in range(len(board)):
        if board[i][pos[1]] == num and pos[0] != i:
            return False
    box_x = pos[1] // 3
    box_y = pos[0] // 3
    for i in range(box_y * 3, box_y * 3 + 3):
        for j in range(box_x * 3, box_x * 3 + 3):
            if board[i][j] == num and (i, j) != pos:
                return False
    return True

def find_empty(board):
    for i in range(len(board)):
        for j in range(len(board[0])):
            if board[i][j] == 0:
                return (i, j) 
    return None

def write_sudoku_to_file(grid, filename):
    # output for the tester
    with open(f"{filename}_cairo.txt", 'w') as file:
        for row in grid:
            for num in row:
                file.write(f'    arr.append({num});\n')
    # output for the smart contract  
    with open(f"{filename}_contract.txt", 'w') as file:
        for row in grid:
            for num in row:
                file.write(f'{num} ')


if __name__ == "__main__":
    board = generate_sudoku()
    temp = copy.deepcopy(board)
    print("Generated Sudoku Board")
    print_board(board, "output//sudoku_unsolved.txt")
    solve(temp)
    print("\nSolved Sudoku Board")
    print_board(temp, "output//sudoku_solved.txt")
    print("\nExported Sudoku Board")
    write_sudoku_to_file(temp, 'output//sudoku')


# # Example usage
# sudoku = generate_sudoku()
# write_sudoku_to_file(sudoku, 'sudoku.txt')
