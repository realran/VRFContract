// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/bn256/BN256.sol";

contract VRF {

  struct Proof {
    bytes pk;
    bytes signature;
    uint256 seed;
  }

  function toBytes(uint256 x) internal pure returns (bytes memory) {
    bytes memory b = new bytes(32);
    assembly {
      mstore(add(b, 32), x) 
    }
    return b;
  }

  function randomValueFromVRFProof(Proof memory proof) internal view returns (bool) {
    return BN256.verifySignature(
      proof.pk,
      toBytes(proof.seed),
      proof.signature
    );
  }
}
