// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract RomanNumeralsEncoder {
    bytes7 constant ROMAN_NUMERAL = 'IVXLCDM';

    function solution(uint num) external pure returns (string memory) {
        bytes memory res = '';

        for (uint count; num > 0; count += 2) {
            uint digit = num % 10;
            num /= 10;

            if (digit == 9) {
                res = bytes.concat(ROMAN_NUMERAL[count], ROMAN_NUMERAL[count + 2], res);
            } else if (digit > 4) {
                bytes memory part = '';

                for (uint repeat = digit - 5; repeat > 0; --repeat) {
                    part = bytes.concat(part, ROMAN_NUMERAL[count]);
                }

                res = bytes.concat(ROMAN_NUMERAL[count + 1], part, res);
            } else if (digit == 4) {
                res = bytes.concat(ROMAN_NUMERAL[count], ROMAN_NUMERAL[count + 1], res);
            } else if (digit > 0) {
                bytes memory part = '';

                for (uint repeat; repeat < digit; ++repeat) {
                    part = bytes.concat(part, ROMAN_NUMERAL[count]);
                }

                res = bytes.concat(part, res);
            }
        }

        return string(res);
    }
}
