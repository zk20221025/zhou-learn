// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./34_ERC721.sol";

library MerkleProof {
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        return processProof(proof , leaf) == root;
    }

    function processProof(bytes32[] memory proof , bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0 ; i < proof.length; i++) {
            computedHash = _hashPair(computedHash , proof[i]);
        }
        return computedHash;
    }

    function _hashPair(bytes32 a , bytes32 b) private pure returns (bytes32) {
       return a < b ? keccak256(abi.encodePacked(a,b)) : keccak256(abi.encodePacked(b,a)); 
    }
}