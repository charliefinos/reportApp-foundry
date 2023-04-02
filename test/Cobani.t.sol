// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Cobani.sol";

// user should be able to upload an infraction
// worker should be able to see all submited infractions
// worker should be able to verify an infraction
// worker should be able to reject an infraction
// user should be able to withdraw funds after infraction is verified

contract CounterTest is Test {
    Cobani public cobani;

    // Create a user wallet
    // Can be used any number or a real address to fork
    address user1 = address(1);

    string ipfsHashExample = "QmeB8iX7UWK4JLMxRPSAhShH2tc9mUkmGodD5CqeJpGfk6";

    bytes32 ipfsHashExampleBytes = keccak256(abi.encodePacked(ipfsHashExample));

    function setUp() public {
        // Initialize the contract
        cobani = new Cobani();

        // Give user1 some ether
        vm.deal(user1, 1 ether);
    }

    function testSubmitInfraction() public {
        // Connect as user1
        vm.startPrank(user1);
        cobani.submitInfraction(ipfsHashExample);
        vm.stopPrank();

        (bytes32 hashh, , , ) = cobani.infractions(ipfsHashExampleBytes);

        assertEq(hashh, ipfsHashExampleBytes);
    }
}
