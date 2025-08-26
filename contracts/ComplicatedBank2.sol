// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract ComplicatedBank2 {
    mapping(address => uint256) balances;
    address[] public accounts;
    uint public rate = 3;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function totalInteresPerYear() public view onlyOwner returns (uint256) {
        uint256 totalInterest = 0;
        for (uint i = 0; i < accounts.length; i++) {
            totalInterest += calculateInterest(accounts[i]);
        }
        return totalInterest;
    }

    function getSystemBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    function calculateInterest(address _address) public view returns (uint256) {
        uint256 interest = balances[_address] * rate / 100;
        return interest;
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        accounts.push(msg.sender);
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] > amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Withdraw failed!!");
        balances[msg.sender];
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    // function withdraw() public payable {
    //     uint amount = msg.value;
    //     require(balances[msg.sender] > amount, "Insufficient balance");
    //     balances[msg.sender] -= amount;
    //     (bool success, ) = msg.sender.call{value: amount}("");
    //     require(success, "Withdraw failed!!");
    // }

    // function getAllBalance() public view returns (uint256) {
    //     return address(this).balance;
    // }
}