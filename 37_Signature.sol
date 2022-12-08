// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./34_ERC721.sol";

library ECDSA {
    function verify( bytes32 _msgHash , bytes memory _signature , address _signer) internal pure returns (bool) {
        return recoverSigner(_msgHash , _signature) == _signer;
    }

    function recoverSigner(bytes32 _msgHash , bytes memory _signature) internal pure returns (address) {
        require(_signature.length == 65 , "invalid signature length");
        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            r := mload(add(_signature , 0x20))
            s := mload(add(_signature , 0x40))
            v := byte(0 , mload(add(_signature , 0x60)))
        }
        return ecrecover(_msgHash , v , r , s);
    }

    function toEthSignedMessageHash(bytes32 hash) public pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32" , hash));
    }
}