// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract AucEngine {
    address public owner;
    uint constant DURATION = 2 days; // u can use "immutable" - we can initialize in constructor
    uint constant FEE = 10;
    struct Auction {
        address payable seller;
        uint startingPrice;
        uint finalPrice;
        uint startsAt
    }
}
