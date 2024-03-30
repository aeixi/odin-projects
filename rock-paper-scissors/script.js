function getComputerChoice() {
    const choices = ["rock", "paper", "scissors"];
    let random = Math.floor(Math.random()*3);
    return choices[random]
}

function playRound(playerChoice, computerChoice) {
    playerChoice = playerChoice.toLowerCase();
    switch (playerChoice) {
        case "rock":
            if (computerChoice == "rock") {
                return "You tied!";
            }
            else if (computerChoice == "paper") {
                return "You lose! Paper beats rock!" 
            }
            else {
                return "You win! Rock beats scissors!"
            }
        case "paper":
            if (computerChoice == "rock") {
                return "You Win! Paper beats rock!";
            }
            else if (computerChoice == "paper") {
                return "You tied!" 
            }
            else {
                return "You lose! Scissors beats paper!"
            }
        case "scissors":
            if (computerChoice == "rock") {
                return "You lose! Rock beats scissors!!";
            }
            else if (computerChoice == "paper") {
                return "You win! Scissors beats paper!" 
            }
            else {
                return "You tied!"
            }
        default:
            return playerChoice + " is not a valid option!"
    } 
}

let playerChoice = "rock";

console.log(playRound(playerChoice, getComputerChoice()));