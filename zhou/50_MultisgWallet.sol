// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MultisigWallet {
    event ExecutionSuccess(bytes32 txHash);
    event ExecutionFailure(bytes32 txHash);
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public ownerCount;
    uint256 public threshold;
    uint256 public nonce;

    receive() external payable {}
    
    constructor(
        address[] memory _owners,
        uint256 _threshold
    ) {
        _setupOwners(_owners , _threshold);
    }
}