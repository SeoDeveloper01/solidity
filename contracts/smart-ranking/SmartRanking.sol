// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract SmartRanking {
    struct Student {
        uint rollNumber;
        uint marks;
    }

    Student[] private students;
    bool private isSorted;

    function insertMarks(uint rollNumber, uint marks) external {
        if (isSorted) isSorted = false;
        students.push(Student(rollNumber, marks));
    }

    function scoreByRank(uint rank) external returns (uint) {
        require(rank > 0);
        require(rank <= students.length);

        if (!isSorted) sortByRank();

        return students[rank - 1].marks;
    }

    function rollNumberByRank(uint rank) external returns (uint) {
        require(rank > 0);
        require(rank <= students.length);

        if (!isSorted) sortByRank();

        return students[rank - 1].rollNumber;
    }

    function sortByRank() private {
        unchecked {
            for (uint slow; slow < students.length; ++slow) {
                uint maxIndex = slow;

                for (uint fast = slow + 1; fast < students.length; ++fast) {
                    if (students[fast].marks > students[maxIndex].marks) maxIndex = fast;
                }

                if (slow != maxIndex) {
                    Student memory temp = students[slow];

                    students[slow] = students[maxIndex];
                    students[maxIndex] = temp;
                }
            }
        }
    }
}
