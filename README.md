# reportApp Contract
The reportApp contract is used to submit and verify infractions. It's written in Solidity and runs on the Ethereum blockchain.

![alt text](https://storage.googleapis.com/charliefiles/Screenshot%202023-04-02%20at%2016.00.25.png)

### Functionality
The contract allows users to submit an infraction by providing the IPFS hash of the infraction. Only one infraction per user is allowed. Workers with the correct role can then verify the infraction by setting the `verified` and `accepted` boolean values in the `Infraction` struct. If `accepted` is false, the infraction is deleted from the contract.

Usage
Submitting an Infraction
To submit an infraction, call the `submitInfraction` function and provide the IPFS hash of the infraction as a string parameter.

Verifying an Infraction
To verify an infraction, call the `verifyInfraction` function and provide the address of the user who submitted the infraction, as well as a boolean value for `isAccepted` to indicate whether the infraction is valid or not.

Getting an Infraction
To read an existing infraction, call the `getInfraction` function and provide the address of the user who submitted the infraction.

Roles
The contract uses access control to restrict certain functions to workers with the correct role. The `WORKER_ROLE` constant is used to identify workers. Only the contract owner can add or remove workers from the contract.

Events
The contract emits two events: `InfractionSubmitted` when an infraction is submitted, and `InfractionVerified` when an infraction is verified.

All events are monitored by our api

Dependencies
The contract uses the OpenZeppelin libraries `Ownable` and `AccessControl`.

License
This contract is released under the Unlicense. See the LICENSE file for more information.