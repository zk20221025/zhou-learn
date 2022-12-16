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

    function _setupOwners(address[] memory _owners , uint256 _threshold) internal {
        require(threshold == 0 , "WTF5000");
        require(_threshold <= _owners.length, "WTF5001");
        require(_threshold >= 1 , "WTF5002");

        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0) && owner != address(this) && !isOwner[owner] , "WTF5003");
            owners.push(owner);
            isOwner[owner] = true;
        }
        ownerCount = _owners.length;
        threshold = _threshold;
    }
}