function getComputerChoice() {
    const choices = ["rock", "paper", "scissors"];
    let random = Math.floor(Math.random()*3);
    return choices[random]
}