// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    // Require - error
    // Revert - error
    // Assert - panic error
    address owner;

    event Paid(address _from, uint _amount, uint _timestamp);

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(address _to) {
        require(msg.sender == owner, "you're not the owner");
        require(_to != address(0), "incorrect address!");
        _;
        //require(...);
    }

    receive() external payable {
        pay();
    }

    function pay() public payable{
        emit Paid(msg.sender, msg.value, block.timestamp);
    }

    function withdraw(address payable _to) external onlyOwner(_to){
        assert(msg.sender == owner);
        require(msg.sender == owner, "you're not the owner");
        if(msg.sender != owner){
            revert("you're not the owner");
        }
        
        _to.transfer(address(this).balance);
    }
}