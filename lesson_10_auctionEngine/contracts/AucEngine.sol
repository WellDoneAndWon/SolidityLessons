// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract AucEngine {
    address public owner;
    uint constant DURATION = 2 days; // u can use "immutable" - we can initialize in constructor
    uint constant FEE = 10; // 10%
    struct Auction {
        address payable seller;
        uint startingPrice;
        uint finalPrice;
        uint startsAt;
        uint endsAt;
        uint discountRate;
        string item;
        bool stopped;
    }

    Auction[] public auctions;
    
    event AuctionCreated(uint index, string itemName, uint startingPrice, uint duration);
    event AuctionEnded(address seller, address winner, uint price)

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not admin!");
        _;
    }

    modifier notStopped() {
        require(!currentAuction.stopped, "Auction was stopped!");
        _;
    }

    function createAuction(uint _startingPrice, uint _discountRate, string calldata _item, uint _duration) external {
        uint duration = _duration == 0 ? DURATION : _duration;

        require(_startingPrice >= _discountRate * duration, "incorrect starting price");

        Auction memory newAuction = Auction({
            seller: payable(msg.sender),
            startingPrice: _startingPrice,
            finalPrice: _startingPrice,
            startsAt: block.timestamp,
            endsAt: block.timestamp + duration,
            discountRate: _discountRate,
            item: _item,
            stopped: false
        });

        auctions.push(newAuction);

        emit AuctionCreated(auctions.length - 1, _item, _startingPrice, duration);
    }

    function getPriceFor(uint index) public view returns(uint) notStopped() {
        Auction memory currentAuction = auctions[index];
        uint elapsed = block.timestamp - currentAuction.startsAt;
        uint discount = elapsed * currentAuction.discountRate;
        return currentAuction.startingPrice - discount;
    }

    function buy(uint index) external payable notStopped() {
        Auction memory currentAuction = auctions[index];
        require(block.timestamp <= currentAuction.endsAt, "Auction was closed!");
        int currentPrice = getPriceFor(index);
        require(msg.value >= currentPrice,"You are trying transfer not enougth funds!");
        currentAuction.finalPrice = currentPrice;
        currentAuction.stopped = true;
        uint refund = msg.value - currentPrice;
        if (refund > 0) {
            (payable)msg.sender.transfer(refund);
        }
        currentAuction.seller.transfer(currentPrice - (currentPrice * FEE)/100);
        emit AuctionEnded(currentAuction.seller, msg.sender, currentPrice)
    }

    function withdrowAllFees() external onlyOwner() {
        (payable)msg.sender.transfer(this.balance);
    }
}
