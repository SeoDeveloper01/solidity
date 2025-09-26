// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract RockPaperScissors {
    event GameCreated(address creator, uint gameNumber, uint bet);
    event GameStarted(address payable[2] players, uint gameNumber);
    event GameComplete(address winner, uint gameNumber);

    struct Game {
        address payable player1;
        address payable player2;
        uint player1Move;
        uint player2Move;
        bool isStarted;
        uint bet;
    }

    mapping(uint => Game) private games;
    uint private lastGameId;

    function createGame(address payable participant) external payable {
        require(msg.value > 0 wei);

        Game memory game;

        game.player1 = payable(msg.sender);
        game.player2 = participant;
        game.bet = msg.value;
        games[lastGameId] = game;

        emit GameCreated(game.player1, ++lastGameId, msg.value);
    }

    function joinGame(uint gameNumber) external payable {
        Game storage game = games[gameNumber];

        require(msg.sender == game.player2);
        require(msg.value >= game.bet);
        require(!game.isStarted);

        if (msg.value > game.bet) game.player2.transfer(msg.value - game.bet);
        game.isStarted = true;

        emit GameStarted([game.player1, game.player2], gameNumber);
    }

    function makeMove(uint gameNumber, uint moveNumber) external {
        Game storage game = games[gameNumber];

        require(moveNumber == 1 || moveNumber == 2 || moveNumber == 3);
        require(game.isStarted);

        if (game.player1 == msg.sender) game.player1Move = moveNumber;
        else game.player2Move = moveNumber;

        if (game.player1Move != 0 && game.player2Move != 0) emit GameComplete(findWinner(gameNumber), gameNumber);
    }

    function findWinner(uint gameNumber) private returns (address winner) {
        Game storage game = games[gameNumber];

        if (game.player1Move == game.player2Move) {
            game.player1.transfer(game.bet);
            game.player2.transfer(game.bet);
        } else if (
            (game.player1Move == 1 && game.player2Move == 3) ||
            (game.player1Move == 2 && game.player2Move == 1) ||
            (game.player1Move == 3 && game.player2Move == 2)
        ) {
            game.player1.transfer(game.bet + game.bet);
            winner = game.player1;
        } else {
            game.player2.transfer(game.bet + game.bet);
            winner = game.player2;
        }

        delete games[gameNumber];
    }
}
