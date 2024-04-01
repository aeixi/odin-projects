function getComputerChoice() {
    const choices = ["rock", "paper", "scissors"];
    let random = Math.floor(Math.random()*3);
    return choices[random]
}

function playRound(playerChoice, computerChoice) {
    playerChoice = playerChoice.toLowerCase();
    if (playerChoice == computerChoice) {
        return "tie";
    }
    else if (playerChoice == "rock" && computerChoice == "scissors" ||
    playerChoice == "paper" && computerChoice == "scissors" ||
    playerChoice == "scissors" && computerChoice == "rock") {
        return "win";
    }
    else {
        return "lose";
    }
}

function playGame() {
    let playerScore = 0;
    let computerScore = 0;

    while (playerScore < 3 && computerScore < 3) {
        let playerChoice = prompt("Enter rock, paper, or scissors: ");
        let computerChoice = getComputerChoice();
        let result = playRound(playerChoice, computerChoice);

        switch (result) {
            case ("win"):
                console.log("You have won! " + playerChoice + " beats " + computerChoice);
                playerScore++;
                break;
            case ("lose"):
                console.log("You have lost! "  + playerChoice + " beats " + computerChoice);
                computerScore++;
                break;
            case ("tie"):
                console.log("You tied!");
                break;
        }
    }

    if (playerScore == 3) {
        console.log("You have won!");
    }
    else if (computerScore == 3) {
        console.log("You have lost!");
    }
}

playGame();