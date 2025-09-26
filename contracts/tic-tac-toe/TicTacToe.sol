// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TicTacToe {
    function isSolved(int[3][3] calldata grid) external pure returns (int) {
        int[3] memory rows;
        int[3] memory cols;
        int diag1;
        int diag2;
        uint moves;

        for (uint row; row < 3; ++row) {
            for (uint col; col < 3; ++col) {
                if (grid[row][col] != 0) {
                    int player = grid[row][col] == 1 ? int(1) : -1;

                    if (row == col) diag1 += player;
                    if (row + col == 2) diag2 += player;
                    rows[row] += player;
                    cols[col] += player;
                    ++moves;
                }
            }
        }

        if (diag1 == 3 || diag2 == 3) return 1;
        if (diag1 == -3 || diag2 == -3) return 2;

        for (uint index; index < 3; ++index) {
            if (rows[index] == 3 || cols[index] == 3) return 1;
            if (rows[index] == -3 || cols[index] == -3) return 2;
        }

        return moves == 9 ? int(0) : -1;
    }
}
