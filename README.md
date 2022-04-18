# VRFContract
PlatON built-in contract (contract address: 0x30000000000000000000000000000000000001) generates VRF random numbers for users. The Solidity contracts in this repository refer to the usage of Chainlink VRF, encapsulate the invocation of built-in contracts, and at the same time make the entire invocation process of the contract consistent with Chainlink, so that users can quickly migrate Chainlink VRF-based services to PlatON VRF.

# Contract Overview

## VRF.sol
The VRF contract directly calls the PlatON built-in contract through delegatecall and returns a list of random numbers. If the user's current business does not involve the Chainlink VRF process, the contract can be deployed directly.

## VRFCoordinatorV2.sol
The Coordinator contract refers to Chainlink VRF related contracts, and provides subscription management and Consumer contract registration functions, which is convenient for Consumer contracts to access and use VRF functions. Different from Chainlink VRF, the Coordinator contract provides users with two ways to obtain random numbers, i.e. the synchronous and the asynchronous, and cancels the settlement of Link Token related fees.

## VRFv2Consumer.sol
The contract provides a Consumer contract template, to which users can refer to call the Coordinator contract to obtain random numbers for business processing.

# Contract Usage

1. Deploy the VRCoordinatorV2 contract and the contract address vrfCoordinatorAddress is returned.

2. Create a Subscription in VRCoordinatorV2 and the subscription SubId is returned.

3. Deploy the VRFv2Consumer contract, pass in vrfCoordinatorAddress and SubId as the constructor parameters, and the contract address consumerAddress is returned.

4. Register the Consumer contract with VRCoordinatorV2, pass in SubId and consumerAddress as parameters.

5. Call the syncRequestRandomWords method of the Consumer contract to obtain a list of random numbers synchronously.

6. Call the requestRandomWords method of the Consumer contract to asynchronously request VRF random numbers, and the generated random numbers are returned by the callback function fulfillRandomWords.
