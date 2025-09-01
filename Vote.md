# Vote Smart Contact
Source code
```
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
        require(!isVoted[msg.sender], "alredy Vote!");      
        votesReceived[candidateName] += 1;
        isVoted[msg.sender] = true;
    }

    function totalVotesFor(string memory candidate) public inState(State.Ended) view returns (uint) {
        return votesReceived[candidate];
    }
}
```
## อธิบายโค้ด
### 1. onlyOffical คือตรวจสอบสิทธ์การเข้าถึง function
```
    modifier onlyOfficial() {
        require(msg.sender == officialAddress, "ONLY Official");
        _;
    }
```

### 2. inState เช็คว่า State ปัจจุบันตรงกับที่รับเข้ามา จะทำให้ไม่สามารถย้อนกลับมาใช้ function ก่อนหน้านี้ได้
```
    modifier inState(State _state){
        require(state == _state, "INCORRECT STATE");
        _;
    }
```
### 3. StartVote จะเริ่มทำการโหวตและเปลี่ยน State แต่ต้องเป็น official เท่านั้น
```
    function startVote() public inState(State.Created) onlyOfficial {
        //require(officialAddress == msg.sender, "ONLY Official");  - move to be modifier
        // require(state == _state);  - move to be modifier
        state = State.Voting;
    }
```

### 3. StopVote จะปิดทำการโหวตและเปลี่ยน State แต่ต้องเป็น official เท่านั้น
```
    function endVote() public inState(State.Voting) onlyOfficial {
        state = State.Ended;
    }
```

### 4. voteForCandidate คือการโหวตเลือก สามารถโหวตได้แค่ 1 รอบ
```
    function voteForCandidate(string memory candidateName) public inState(State.Voting) {   
        require(!isVoted[msg.sender], "alredy Vote!");      
        votesReceived[candidateName] += 1;
        isVoted[msg.sender] = true;
    }
```

### 5. totalVotesFor รวมคะแนนโหวตโดยรับ Parameter เป็นชื่อ candidate
```
    function totalVotesFor(string memory candidate) public inState(State.Ended) view returns (uint) {
        return votesReceived[candidate];
    }
```