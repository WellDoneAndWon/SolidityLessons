// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DemoSAM {
    address public myAddr = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    string public myStr = "test"; //storage

    mapping (address => uint) public payments;

    function transferTo(address payable targetAddr, uint amount) public {
        targetAddr.transfer(amount);
    }

    function recieveContract() public payable {
        payments[msg.sender] = msg.value;
    }

    function getBalance(address targetAddr) public view returns(uint) {
        return targetAddr.balance;
    }

    function demo(string memory newValueStr) public {
        string memory myTempStr = "temp";
        myStr = newValueStr;
    }
}