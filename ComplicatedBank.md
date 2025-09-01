# ComplicatedBank.md
ตัวอย่างโค้ด
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract ComplicatedBank {
    mapping(address => uint256) balances;
    address[] public accounts;
    uint public rate = 3;
    address public owner;

    constructor() {
        owner = msg.sender;
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
}
```

# อธิบายโค้ด
### 1. function getSystemBalance คือฟังก์ชั่นที่เอาไว้แสดงยอดเงินฝากในธนาคาร และจะสามารถดูได้แค่เจ้าของธนาคารเท่านั้นก็คือ Account ที่เป็นคน Deploy จะเก็บค่าใน constructor ตอน deploy
```
    function getSystemBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
```
Result:
![image](https://drive.google.com/file/d/1QI63Um4fgDW2igASJK_VcX3z72UvMQjN)

### 2. function calculateInterest คือฟังก์ชั่นที่คำนวณดอกเบี้ยจากจำนวณเงินฝาก และคำนวณจาก Account ที่ใส่เข้ามาใน Parameter
```
    function calculateInterest(address _address) public view returns (uint256) {
        uint256 interest = balances[_address] * rate / 100;
        return interest;
    }
```

### 3. function getBalance คือฟังก์ชั่นที่ดูยอดเงินฝากในบัญชี
```
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
```

### 4. function deposit และ withdraw คือฟังก์ชั่นไว้ฝากเงินและถอนเงิน
```
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] > amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Withdraw failed!!");
        balances[msg.sender];
    }
```

