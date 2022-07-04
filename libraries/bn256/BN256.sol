// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import {BlsSignatureVerification as BLS} from "./BlsSignatureVerification.sol";


library BN256 {

    function verifySignature(
        bytes memory _publicKey,  // an E2 point
        bytes memory _message,
        bytes memory _signature   // an E1 point
    ) internal view returns (bool) {
        BLS.E2Point memory pub = decodeE2Point(_publicKey);
        BLS.E1Point memory sig = decodeE1Point(_signature);
        return BLS.verify(pub, _message, sig);
    }

    function verifySignaturePoint(
        bytes memory _publicKey,  // an E2 point
        bytes memory _message,    // an E1 point
        bytes memory _signature   // an E1 point
    ) internal view returns (bool)  {
        BLS.E2Point memory pub = decodeE2Point(_publicKey);
        BLS.E1Point memory sig = decodeE1Point(_signature);
        return BLS.verifyForPoint(pub, decodeE1Point(_message), sig);
    }

    function verifyMultisignature(
        bytes memory _aggregatedPublicKey,  // an E2 point
        bytes memory _partPublicKey,        // an E2 point
        bytes memory _message,
        bytes memory _partSignature,        // an E1 point
        uint _signersBitmask
    ) internal view returns (bool)  {
        BLS.E2Point memory aPub = decodeE2Point(_aggregatedPublicKey);
        BLS.E2Point memory pPub = decodeE2Point(_partPublicKey);
        BLS.E1Point memory pSig = decodeE1Point(_partSignature);
        return BLS.verifyMultisig(aPub, pPub, _message, pSig, _signersBitmask);
    }

    function verifyAggregatedHash(
        bytes memory _p,
        uint index
    ) internal view returns (bytes memory) {
        BLS.E2Point memory pub = decodeE2Point(_p);
        bytes memory message = abi.encodePacked(pub.x, pub.y, index);
        BLS.E1Point memory h = BLS.hashToCurveE1(message);
        return abi.encodePacked(h.x, h.y);
    }

    function addOnCurveE1(
        bytes memory _p1,
        bytes memory _p2
    ) internal view returns (bytes memory) {
        BLS.E1Point memory res = BLS.addCurveE1(decodeE1Point(_p1), decodeE1Point(_p2));
        return abi.encode(res.x, res.y);
    }

    function decodeE2Point(bytes memory _pubKey) private pure returns (BLS.E2Point memory pubKey) {
        uint256[] memory output = new uint256[](4);
        for (uint256 i = 32; i <= output.length * 32; i += 32) {
            assembly { mstore(add(output, i), mload(add(_pubKey, i))) }
        }

        pubKey.x[0] = output[0];
        pubKey.x[1] = output[1];
        pubKey.y[0] = output[2];
        pubKey.y[1] = output[3];
    }

    function decodeE1Point(bytes memory _sig) private pure returns (BLS.E1Point memory signature) {
        uint256[] memory output = new uint256[](2);
        for (uint256 i = 32; i <= output.length * 32; i += 32) {
            assembly { mstore(add(output, i), mload(add(_sig, i))) }
        }

        signature.x = output[0];
        signature.y = output[1];
    }
}