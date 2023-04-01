// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Cobani {
    // mapping(address => uint256) public balances;

    struct Infraction {
        bytes32 ipfsHash;
        uint256 timestamp;
        address userAddress;
        bool verified;
    }

    constructor() {}
}
