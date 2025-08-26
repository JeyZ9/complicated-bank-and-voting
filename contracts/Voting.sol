// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

contract Voting{
    address public officialAddress;
    string[] public candidateList;
    mapping(string => uint256) votesReceived;
    mapping(address => bool) public isVoted;

    //ประกาศตัวแปรประเภท enum ชื่อ State มีค่าเป็นไปได้คือ  Created/ Voting/ Ended
    enum State {Created, Voting, Ended}  

    //ประกาศตัวแปรประเภท state มีชนิดข้อมูลเป็น State 
    State public state;

    constructor(string[] memory _candidateList) {
        officialAddress = msg.sender;
        candidateList = _candidateList;
        state = State.Created;
    }

    modifier onlyOfficial() {
        require(msg.sender == officialAddress, "ONLY Official");
        _;
    }

    modifier inState(State _state){
        require(state == _state, "INCORRECT STATE");
        _;
    }

    function startVote() public inState(State.Created) onlyOfficial {
        //require(officialAddress == msg.sender, "ONLY Official");  - move to be modifier
        // require(state == _state);  - move to be modifier
        state = State.Voting;
    }

    function endVote() public inState(State.Voting) onlyOfficial {
        state = State.Ended;
    }

    function voteForCandidate(string memory candidateName) public inState(State.Voting) {         
        
        votesReceived[candidateName] += 1;
    }

    function totalVotesFor(string memory candidate) public inState(State.Ended) view returns (uint) {
        return votesReceived[candidate];
    }
}