// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Un { // Gas used: 296233
    uint public result = 7;
    function doWork(uint[] memory data) public { // Gas used: 30254
        for(uint i = 0; i < data.length; i++){
            result *= data[i];
        }
    }
}

contract Op { // Gas used: 297085
    uint public result = 7;
    function doWork(uint[] memory data) public { // Gas used: 29824
        uint temp = 7;
        for(uint i = 0; i < data.length; i++){
            temp *= data[i];
        }
        result = temp;
    }
}


