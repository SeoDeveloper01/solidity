# Smart Ranking

Alice has developed an online software that takes exams of students using complex algorithms, which consider multiple factors such as the quality of the solution, submission time, etc. to ensure that no two students obtain the same marks.

Bob wants to write a smart contract that stores the results of the students and can give real-time output of the number of students who have submitted their exam.

This smart contract keeps track of the roll numbers and marks obtained by students.

## Input:

-   `insertMarks(uint rollNumber, uint marks)`: This function allows the software to insert the roll number and corresponding marks of a student who has taken the exam. The marks of students and their roll numbers are unsigned integers not greater than or equal to 2<sup>256</sup>, i.e., `0 <= rollNumber < 2**256` and `0 <= marks < 2**256`.

## Output:

-   `scoreByRank(uint rank) returns (uint)`: This function returns the marks obtained by a student who has a particular rank;

-   `rollNumberByRank(uint rank) returns (uint)`: This function returns the roll number of a student who has a particular rank.
