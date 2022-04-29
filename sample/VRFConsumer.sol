// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../dev/VRFCoordinator.sol";
import "../VRFConsumerBase.sol";

contract VRFConsumer is VRFConsumerBase {
  VRFCoordinator COORDINATOR;

  // The gas lane to use, which specifies the maximum gas price to bump to.
  // For a list of available gas lanes on each network,
  bytes32 keyHash = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;

  // Your subscription ID.
  uint64 s_subscriptionId;

  // PlatON Devnet coordinator.
  address vrfCoordinator = 0x356d552150f460f57Cd722DC4f3D03A3f2B8386C;

  // Depends on the number of requested values that you want sent to the
  // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
  // so 100,000 is a safe default for this example contract. Test and adjust
  // this limit based on the network that you select, the size of the request,
  // and the processing of the callback request in the fulfillRandomWords()
  // function.
  uint32 callbackGasLimit = 100;

  // The default is 3, but you can set this higher.
  uint16 requestConfirmations = 100;

  uint256 public s_requestId;
  address s_owner;

  uint256[] public s_randomWords;

  constructor() VRFConsumerBase(vrfCoordinator) {
    COORDINATOR = VRFCoordinator(vrfCoordinator);
    s_owner = msg.sender;
    createNewSubscription();
  }

  // Create a new subscription when the contract is initially deployed.
  function createNewSubscription() internal {
    // Create a subscription with a new subscription ID.
    address[] memory consumers = new address[](1);
    consumers[0] = address(this);
    s_subscriptionId = COORDINATOR.createSubscription();
    // Add this contract as a consumer of its own subscription.
    COORDINATOR.addConsumer(s_subscriptionId, consumers[0]);
  }

  // Call the requestRandomWords method to asynchronously request VRF random numbers
  // and the generated random numbers are returned by the callback function fulfillRandomWords.
  function requestRandomWords(uint32 numWords) external {
    s_requestId = COORDINATOR.requestRandomWords(
      keyHash,
      s_subscriptionId,
      requestConfirmations,
      callbackGasLimit,
      numWords
    );
  }

  // Call the syncRequestRandomWords method to obtain a list of random numbers synchronously.
  function syncRequestRandomWords(uint32 numWords) external {
    uint256[] memory randomWords = COORDINATOR.syncRequestRandomWords(
      keyHash,
      s_subscriptionId,
      requestConfirmations,
      callbackGasLimit,
      numWords
    );
    s_randomWords = randomWords;
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
