// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/AggregatorV3Interface.sol";

contract Aggregator is AggregatorV3Interface {

  function decimals() external pure returns (uint8) {
      return 18;
  }

  function description() external pure returns (string memory) {
      return "LATTOKEN / LAT";
  }

  function version() external pure returns (uint256) {
      return 1;
  }

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(uint80 _roundId) external view returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    ) {
        return (0,0,0,block.timestamp,0);
    }

  function latestRoundData() external view returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    ) {
        return (0,0,0,block.timestamp,0);
    }
}