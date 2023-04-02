// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Cobani is Ownable {
    mapping(address => Infraction) public infractions;

    uint256 public infractionCount;

    event InfractionSubmitted(
        bytes32 ipfsHash,
        uint256 id,
        address userAddress
    );

    error InfractionAlreadyExists(address cobaniAddress);
    error InfractionPendingVerification(address cobaniAddress);
    error InfractionDoesNotExist(address cobaniAddress);
    error InfractionAlreadyVerified(address cobaniAddress);

    /// @notice this struct is used to store an infraction
    /// @dev accepted bool is valid only if verified is true
    struct Infraction {
        bytes32 ipfsHash;
        uint256 timestamp;
        bool verified;
        bool accepted;
    }

    constructor() {}

    /// @notice this function is used to submit an infraction
    /// @notice only one infraction per user is allowed
    /// @param _ipfsHash the hash of the infraction
    function submitInfraction(string memory _ipfsHash) public {
        if (infractions[msg.sender].timestamp != 0) {
            revert InfractionPendingVerification(ipfsHash);
        }

        bytes32 ipfsHash = keccak256(abi.encodePacked(_ipfsHash));

        Infraction memory infraction = Infraction({
            ipfsHash: ipfsHash,
            timestamp: block.timestamp,
            verified: false,
            accepted: false
        });

        infractions[msg.sender] = infraction;

        emit InfractionSubmitted(ipfsHash, msg.sender);
    }

    /// @notice this function is used for state worker to verify an infraction
    /// @dev we should consider adding access control
    function verifyInfraction(
        address cobaniAddress,
        bool isAccepted
    ) public onlyOwner {
        if (infractions[cobaniAddress].timestamp == 0) {
            revert InfractionDoesNotExist(cobaniAddress);
        }

        if (infractions[cobaniAddress].verified) {
            revert InfractionAlreadyVerified(cobaniAddress);
        }

        Infractions storage infraction = infractions[cobaniAddress];

        infraction.verified = true;

        if (isAccepted) {
            infraction.accepted = true;
        } else {
            delete infraction;
        }
    }

    // @notice this function reads an existing infraction
    // @param _ipfsHash the hash of the infraction
    function getInfraction(
        string memory _ipfsHash
    ) public view returns (Infraction memory) {
        bytes32 ipfsHash = keccak256(abi.encodePacked(_ipfsHash));

        if (infractions[ipfsHash].timestamp == 0) {
            revert InfractionDoesNotExist(ipfsHash);
        }

        return infractions[ipfsHash];
    }
}
