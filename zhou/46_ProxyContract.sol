// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Proxy {
    address public implementation;

    constructor(address implementation_) {
        implementation = implementation_;
    }

    fallback() external payable {
        _delegate();
    }

    function _delegate() internal {
        assembly {
            let _implementation := sload(0)
            calldatacopy(0 , 0 , calldatasize())
            let result := delegatecall(gas() , _implementation , 0 , calldatasize() , 0 , 0)
            returndatacopy(0 , 0 , returndatasize())
            switch result
            case 0 {
                revert(0 , returndatasize())
            }
            default {
                return(0 , returndatasize())
            }
        }
    }
}