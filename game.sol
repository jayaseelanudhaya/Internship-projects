// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OddEvenGame {
    address payable public player1;
    address payable public player2;
    uint256 public betAmount;
    uint256 public player1Choice;
    uint256 public player2Choice;
    bool public gameFinished;
    
    event GameStarted(address player1, address player2, uint256 betAmount);
    event GameFinished(address winner, uint256 winnings);
    
    constructor() {
        player1 = payable(msg.sender);
        betAmount = 0;
        gameFinished = false;
    }
    
    function joinGame() public payable {
        require(!gameFinished, "Game is already finished.");
        require(msg.value == betAmount, "Incorrect bet amount.");
        require(player2 == address(0), "The game is already full.");
        
        player2 = payable(msg.sender);
        emit GameStarted(player1, player2, betAmount);
    }
    
    function makeChoice(uint256 choice) public {
        require(msg.sender == player1 || msg.sender == player2, "You are not a player in this game.");
        require(choice == 0 || choice == 1, "Invalid choice. Enter 0 for even or 1 for odd.");
        require(!gameFinished, "Game is already finished.");
        
        if (msg.sender == player1) {
            player1Choice = choice;
        } else {
            player2Choice = choice;
        }
        
        if (player1Choice != 0 && player2Choice != 0) {
            determineWinner();
        }
    }
    
    function determineWinner() private {
        uint256 sum = player1Choice + player2Choice;
        address payable winner;
        uint256 winnings;
        
        if (sum % 2 == 0) {
            winner = player1;
        } else {
            winner = player2;
        }
        
        winnings = betAmount * 2;
        emit GameFinished(winner, winnings);
        
        // Transfer winnings to the winner
        winner.transfer(winnings);
        
        // Reset game state
        player1Choice = 0;
        player2Choice = 0;
        gameFinished = true;
    }
}
