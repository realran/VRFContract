// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@realrancrypto/contracts@2.1.0/src/interfaces/VRFCoordinatorV2Interface.sol";
import "@realrancrypto/contracts@2.1.0/src/VRFConsumerBaseV2.sol";

contract ConsumerWithSubManager is VRFConsumerBaseV2 {

 VRFCoordinatorV2Interface COORDINATOR;

 // Your subscription ID.
 uint64 s_subscriptionId;

 // The proving key hash key associated with the bls public key
 bytes32 keyHash = 0x818b4b257c281d2e4db77e3bb13733185a31ab805d863047ef7093e2379e87cd;

 // PlatON Devnet coordinator.
 address vrfCoordinator = 0x67dc19ca89EA3D322B8C7cC4AD2B3BA7bDF2d089;

 // A reasonable default is 2000000, but this value could be different
 // on other networks.
 uint32 callbackGasLimit = 2000000;

 // The default is 3, but you can set this higher.
 uint16 requestConfirmations = 3;

 uint256 public s_requestId;

 address s_owner;

 uint256[] public s_randomWords;

 constructor() VRFConsumerBaseV2(vrfCoordinator) {
  COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
  s_owner = msg.sender;
  createNewSubscription();
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

 // Create a new subscription when the contract is initially deployed.
 function createNewSubscription() private onlyOwner {
  // Create a subscription with a new subscription ID.
  address[] memory consumers = new address[](1);
  consumers[0] = address(this);
  s_subscriptionId = COORDINATOR.createSubscription();
  // Add this contract as a consumer of its own subscription.
  COORDINATOR.addConsumer(s_subscriptionId, consumers[0]);
 }

 function addConsumer(address consumerAddress) external onlyOwner {
  // Add a consumer contract to the subscription.
  COORDINATOR.addConsumer(s_subscriptionId, consumerAddress);
 }

 function removeConsumer(address consumerAddress) external onlyOwner {
  // Remove a consumer contract from the subscription.
  COORDINATOR.removeConsumer(s_subscriptionId, consumerAddress);
 }

 function cancelSubscription(address receivingWallet) external onlyOwner {
  // Cancel the subscription and send the remaining Token to a wallet address.
  // In this version, receivingWallet is a reserved field that users can fill out as they please.
  COORDINATOR.cancelSubscription(s_subscriptionId, receivingWallet);
  s_subscriptionId = 0;
 }

 modifier onlyOwner() {
  require(msg.sender == s_owner);
  _;
 }
}