// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "../interfaces/VRFCoordinatorInterface.sol";
import "../dev/VRFCoordinator.sol";
import "../VRFConsumerBase.sol";

contract VRFConsumer is VRFConsumerBase {
  VRFCoordinator COORDINATOR;

  // The gas lane to use, which specifies the maximum gas price to bump to.
  // For a list of available gas lanes on each network,
  // see https://docs.chain.link/docs/vrf-contracts/#configurations
  bytes32 keyHash = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;

  // Your subscription ID.
  uint64 s_subscriptionId;

  // Depends on the number of requested values that you want sent to the
  // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
  // so 100,000 is a safe default for this example contract. Test and adjust
  // this limit based on the network that you select, the size of the request,
  // and the processing of the callback request in the fulfillRandomWords()
  // function.
  uint32 callbackGasLimit = 100;

  // The default is 3, but you can set this higher.
  uint16 requestConfirmations = 100;

//   uint256[] public s_randomWords;
  uint256 public s_randomWords_length;
  uint256 public s_last_randomWords;

  uint256 public s_requestId;
  address s_owner;

  constructor(address vrfCoordinator, uint64 subscriptionId) VRFConsumerBase(vrfCoordinator) {
    COORDINATOR = VRFCoordinator(vrfCoordinator);
    s_owner = msg.sender;
    s_subscriptionId = subscriptionId;
  }

  // Assumes the subscription is funded sufficiently.
  function requestRandomWords(uint32 numWords) external {
    // Will revert if subscription is not set and funded.
    s_requestId = COORDINATOR.requestRandomWords(
      keyHash,
      s_subscriptionId,
      requestConfirmations,
      callbackGasLimit,
      numWords
    );
  }

  // Assumes the subscription is funded sufficiently.
  function syncRequestRandomWords(uint32 numWords) external {
    // Will revert if subscription is not set and funded.
    uint256[] memory randomWords = COORDINATOR.syncRequestRandomWords(
      keyHash,
      s_subscriptionId,
      requestConfirmations,
      callbackGasLimit,
      numWords
    );
    s_randomWords_length = randomWords.length;
    s_last_randomWords = randomWords[randomWords.length-1];
  }

  function getRandomWords() public view returns(uint256, uint256){
      return (s_randomWords_length, s_last_randomWords);
        // return s_randomWords;
  }
  
  function fulfillRandomWords(
    uint256, /* requestId */
    uint256[] memory randomWords
  ) internal override {
    s_randomWords_length = randomWords.length;
    s_last_randomWords = randomWords[randomWords.length-1];
  }

  modifier onlyOwner() {
    require(msg.sender == s_owner);
    _;
  }
}