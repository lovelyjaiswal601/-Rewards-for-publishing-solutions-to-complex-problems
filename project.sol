// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SolutionRewards {
    address public owner;
    uint256 public rewardAmount;
    uint256 public totalSolutions;
    
    struct Solution {
        address solver; 
        string solutionDescription;
        uint256 timestamp;
    }

    mapping(uint256 => Solution) public solutions;

    event SolutionPublished(address indexed solver, uint256 solutionId, string solutionDescription, uint256 timestamp);
    event RewardIssued(address indexed solver, uint256 rewardAmount, uint256 solutionId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    constructor(uint256 _rewardAmount) {
        owner = msg.sender;
        rewardAmount = _rewardAmount;
        totalSolutions = 0;
    }

    function publishSolution(string memory _solutionDescription) public {
        totalSolutions++;
        solutions[totalSolutions] = Solution(msg.sender, _solutionDescription, block.timestamp);
        
        emit SolutionPublished(msg.sender, totalSolutions, _solutionDescription, block.timestamp);

        // Transfer reward to the solver (can be a token transfer, for simplicity we assume it's Ether here)
        payable(msg.sender).transfer(rewardAmount);

        emit RewardIssued(msg.sender, rewardAmount, totalSolutions);
    }

    function setRewardAmount(uint256 _newRewardAmount) public onlyOwner {
        rewardAmount = _newRewardAmount;
    }

    // Fallback function to accept Ether
    receive() external payable {}
    
    // Function to withdraw contract balance (only owner)
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
