// SPDX-License-Identifier: MIT

// This is an example of consumer contract with some preconditions：
// 1. The subscription has been created and you have got the subId 
// 2. The subscription has been funded with enough balance

pragma solidity ^0.8.0;

import "@realrancrypto/contracts@2.1.0/src/interfaces/VRFCoordinatorV2Interface.sol";
import "@realrancrypto/contracts@2.1.0/src/VRFConsumerBaseV2.sol";

/**
 \* THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 \* THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 \* DO NOT USE THIS CODE IN PRODUCTION.
 */

contract RandomNumberConsumer is VRFConsumerBaseV2 {

 VRFCoordinatorV2Interface COORDINATOR;

 // Your subscription ID.
 uint64 s_subscriptionId = 34;

 // The proving key hash key associated with the bls public key
 bytes32 keyHash = 0x818b4b257c281d2e4db77e3bb13733185a31ab805d863047ef7093e2379e87cd;

 // PlatON Devnet coordinator.
 address vrfCoordinator = 0x67dc19ca89EA3D322B8C7cC4AD2B3BA7bDF2d089;

 // A reasonable default is 2000000, but it depends on the number of requested values that 
 // you want sent to the fulfillRandomWords() function.
 uint32 callbackGasLimit = 2000000;

 // The default is 3, but you can set this higher.
 uint16 requestConfirmations = 3;

 uint256 public s_requestId;

 address s_owner;

 uint256[] public s_randomWords;

 constructor() VRFConsumerBaseV2(vrfCoordinator) {
  COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
  s_owner = msg.sender;
 }

 // Assumes the subscription is funded sufficiently.
 function requestRandomWords(uint32 numWords) external onlyOwner {
  // Will revert if subscription is not set and funded.
  s_requestId = COORDINATOR.requestRandomWords(
   keyHash,
   s_subscriptionId,
   requestConfirmations,
   callbackGasLimit,
   numWords
  );
 }

 function fulfillRandomWords(
  uint256, /* requestId */
  uint256[] memory randomWords
 ) internal override {
  s_randomWords = randomWords;
 }

 modifier onlyOwner() {
  require(msg.sender == s_owner);
  _;
 }
}
