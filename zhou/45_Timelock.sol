// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.4;

contract Timelock {
    event CanceTransaction(bytes32 indexed txHash , address indexed target , uint value , string signature , bytes data , uint executeTime);
    event ExecuteTransaction(bytes32 indexed txHash , address indexed target , uint value , string signature , bytes data , uint executeTime);
    event QueueTransaction(bytes32 indexed txHash , address indexed target , uint value , string signature , bytes data , uint executeTime);
    event NewAdmin(address indexed newAdmin);

    address public admin;
    uint public constant GRACE_PERIOD = 7 days;
    uint public delay;
    mapping (bytes32 => bool) public QueuedTransactions;

    modifier onlyOwner() {
        require(msg.sender == admin , "Timelock: Caller not admin");
        _;
    }

    modifier onlyTimelock() {
        require(msg.sender == address(this) , "Timelock: Caller not Timelock");
        _;
    }

    constructor(uint delay_) {
        delay = delay_;
        admin = msg.sender
    }

    function changeAdmin(address newAdmin) public onlyTimelock {
        admin = newAdmin;
        emit NewAdmin(newAdmin);
    }

    function QueuedTransactions(address target , uint256 value , string memory signature , bytes memory data , uint256 executeTime) public onlyOwner returns (bytes32) {
        require(executeTime >= getBlockTimestamp() + delay , "Timelock::queueTransaction: Estimated execution block must satisfy delay.");
        bytes32 txHash = getTxHash(target , value , signature , data , executeTime);
        QueuedTransactions[txHash] = true;

        emit QueueTransaction(txHash , target , value , signature , data , executeTime);
        return txHash;
    }
}