// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    //enum
    enum Status {Nothing, Paid, Transfering, Recieved}
    Status public currentStatus;

    function pay() public {
        currentStatus = Status.Paid;
    }

    function transferTo() public {
        currentStatus = Status.Transfering;
    }

    function recieve() public {
        currentStatus = Status.Recieved;
    }

    //fixed array
    uint[7] public itemsOne;
    uint[7] public itemsTwo = [1, 2, 3, 7];
    uint[5][6] public items;

    function itemsAdd() public {
        itemsOne[0] = 10;
        itemsOne[1] = 100;
        itemsOne[3] = 300;
    }
    
    function itemsMatrixAdd() public {
        items = [
            [11,15,18,20,25],
            [21,25,28,30,35],
            [111,115,118,120,125],
            [211,215,218,220,225],
            [211,251,250,255,252],
            [55,100,233,133,205]
        ];
    }

    //dynamic array
    uint[] public itemsDynamic;
    uint public len;

    function itemsDynamicAdd() public {
        itemsDynamic.push(3);
        itemsDynamic.push(4);
        itemsDynamic.push(5);
        len = itemsDynamic.length;
    }

    function sampleMemory() public view returns(uint[] memory) {
        uint[] memory tempArray = new uint[](10);
        tempArray[0] = 1;
        tempArray[2] = 1;
        return tempArray;
    }
}