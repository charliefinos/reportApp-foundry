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
    address user2 = address(2);
    address worker1 = address(3);

    string ipfsHashExample = "QmeB8iX7UWK4JLMxRPSAhShH2tc9mUkmGodD5CqeJpGfk6";

    bytes32 ipfsHashExampleBytes = keccak256(abi.encodePacked(ipfsHashExample));

    function setUp() public {
        // Initialize the contract
        cobani = new Cobani();

        // Give user1 some ether
        vm.deal(user1, 1 ether);

        // Give worker role to address(2)
        cobani.setWorkerRole(worker1);

        assertEq(cobani.hasWorkerRole(worker1), true);
    }

    function testSubmitInfraction() public {
        // Connect as user1
        vm.startPrank(user1);
        cobani.submitInfraction(ipfsHashExample);
        vm.stopPrank();

        (bytes32 hashh, , , ) = cobani.infractions(user1);

        assertEq(hashh, ipfsHashExampleBytes);
        // Check event submited

        // Check that the user can't submit another infraction
        vm.prank(user1);
        vm.expectRevert();
        cobani.submitInfraction(ipfsHashExample);
    }

    function testVerifyInfractionTrue() public {
        // Submit infraction as user1
        vm.startPrank(user1);
        cobani.submitInfraction(ipfsHashExample);
        vm.stopPrank();

        // Connect as worker1
        // Verify infraction of user1 as valid
        vm.startPrank(worker1);
        cobani.verifyInfraction(user1, true);
        vm.stopPrank();

        (, , bool verified, bool accepted) = cobani.infractions(user1);

        assertEq(verified, true);
        assertEq(accepted, true);
    }

    function testVerifyInfractionFalse() public {
        // Submit infraction as user2
        vm.startPrank(user2);
        cobani.submitInfraction(ipfsHashExample);
        vm.stopPrank();

        // Connect as worker address(2)
        // Verify infraction of user2 as invalid
        vm.startPrank(worker1);
        cobani.verifyInfraction(user2, false);
        vm.stopPrank();

        (, uint256 timestamp, bool verified, bool accepted) = cobani
            .infractions(user2);

        assertEq(timestamp == 0, true);

        // Verified will be false because the infraction was rejected and struct was deleted
        assertEq(verified, false);
        assertEq(accepted, false);
    }
}
