pragma solidity ^0.5.0;

contract Relayer {
    uint transactionId;

    struct Tx {
        bytes data;
        bool executed;
    }

    mapping (uint => Tx) transactions;

    function relay(Target target, bytes memory _data) public returns(bool) {
        // replay protection; do not call the same transaction twice
        require(transactions[transactionId].executed == false, 'same transaction twice');
        transactions[transactionId].data = _data;
        transactions[transactionId].executed = true;
        transactionId += 1;

        (bool success, ) = address(target).call(abi.encodeWithSignature("execute(bytes)", _data));
        return success;
    }
}

// Contract called by Relayer
contract Target {
    function execute(bytes memory _data) public {
        // Execute contract code
    }
}

contract Relayer {
    uint transactionId;

    struct Tx {
        bytes data;
        bool executed;
    }

    mapping (uint => Tx) transactions;

    function relay(Target target, bytes memory _data, uint _gasLimit) public {
        // replay protection; do not call the same transaction twice
        require(transactions[transactionId].executed == false, 'same transaction twice');
        transactions[transactionId].data = _data;
        transactions[transactionId].executed = true;
        transactionId += 1;

        address(target).call(abi.encodeWithSignature("execute(bytes)", _data, _gasLimit));
    }
}

// Contract called by Relayer
contract Target {
    function execute(bytes memory _data, uint _gasLimit) public {
        require(gasleft() >= _gasLimit, 'not enough gas');
        // Execute contract code
    }
}