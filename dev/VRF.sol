// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/SchnorrSecp256k1.sol";

contract VRF {

  struct Proof {
    uint256 signingPubKeyX;
    uint8 pubKeyYParity;
    uint256 signature;
    bytes pk;
    uint256 seed;
  }

  function toBytes(uint256 x) internal pure returns (bytes memory) {
    bytes memory b = new bytes(32);
    assembly {
      mstore(add(b, 32), x) 
    }
    return b;
  }

  function bytesToAddress(bytes memory pk) private pure returns (address pkAddress) {
    assembly {
      pkAddress := mload(add(pk,20))
    } 
  }

  function randomValueFromVRFProof(Proof memory proof) internal pure returns (bool) {
    return SchnorrSECP256K1.verifySignature(
      proof.signingPubKeyX,
      proof.pubKeyYParity,
      proof.signature,
      proof.seed,
      bytesToAddress(proof.pk)
    );
  }
}