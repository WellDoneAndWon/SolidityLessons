// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Merkle Tree

contract Tree {
    //       ROOT
    //  H1-2      H3-4
    //   [4]       [5]       
    // H1   H2   H3   H4
    // [0]  [1]  [2]  [3]
    // TX1  TX2  TX3  TX4
    bytes32[] public hashes;
    string[4] txs = [
        "TX1: Tom -> Sarah",
        "TX2: Sarah -> John",
        "TX3: John -> Ivan",
        "TX4: Ivan -> Tom"
    ];

    constructor() {
        for(uint i = 0; i < txs.length; i++) {
            hashes.push(makeHash(txs[i]));
        }

        uint count = txs.length;
        uint offset = 0;

        while(count > 0) {
            for(uint i = 0; i < count - 1; i+=2) {
                hashes.push(keccak256(
                    abi.encodePacked(
                        hashes[offset + i], hashes[offset + i + 1]
                    )
                ));
            }
            offset += count;
            count /= 2;
        }        
    }

    function verify(string memory tx, uint index, bytes32 root, bytes32[] memory proof) public pure returns(bool){
    // "TX3: John -> Ivan"
    // 2
    // 0x89c72db06e3c91ba34023e03d9a543bf126b25a1531d8ef3b527092f3ae39420
    // bytes32[] proof = 
    //[0xf5be8aa071965869f2f47340655cd9a20461d9c2c8f464de9a38eb2c3eb2edad, 
    // 0x58b83e71abf320867d1304538cde72f842054aa4c70f1f90c03bc9da556d2b3c] 
    //       ROOT
    //  H1-2      H3-4
    //   [4]       [5]       
    // H1   H2   H3   H4
    // [0]  [1]  [2]  [3]
    // TX1  TX2  TX3  TX4
        bytes32 hash = makeHash(tx);
        for(uint i = 0; i < proof.length; i++){
            bytes32 element = proof[i];
            if(index % 2 == 0) {
                hash = keccak256(abi.encodePacked(hash, element));
            } else {
                hash = keccak256(abi.encodePacked(element, hash));
            }
            index /= 2;
        }
        return hash == root;

    }

    function encode(string memory input) public pure returns(bytes memory) {
        return abi.encodePacked(input);
    }

    function makeHash(string memory input) public pure returns(bytes32){
        return keccak256(
            encode(input)
        );
    }
}