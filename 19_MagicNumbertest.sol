// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MagicNumberSolution {
    function whatIsTheMeaningOfLife() external pure returns (uint256) {
        return 42;
    }
}

//0x60806040526018600055348015601457600080fd5b5060358060226000396000f3006080604052600080fd00a165627a7a723058202ce9376153c7c402971d43c180f7a1c10719b27dad768bebc50b16bc07e901cf0029

//mstore(p, v) return(p, s) 602a60805260206080f3

//0x602a     ;PUSH1 0x2a                  v
//0x6080     ;PUSH1 0x80                  p
//0x52       ;MSTORE

//0x6020     ;PUSH1 0x20                  s
//0x6080     ;PUSH1 0x80                  p
//0xf3       ;RETURN

//codecopy(t, f, s) runtime codes 602a60805260206080f3

//;copy bytecode to memory
//0x600a     ;PUSH1 0x0a                      S(runtime code size)
//0x60??     ;PUSH1 0x??                      F(current position of runtime opcodes)
//0x6000     ;PUSH1 0x00                      T(destination memory index 0)
//0x39       ;CODECOPY

//;return code from memory to EVM
//0x600a     ;PUSH1 0x0a                      S
//0x6000     ;PUSH1 0x00                      P
//0xf3       ;RETURN

//var account = "你的地址在这里"; 
//var bytecode = "0x600a600c600039600a6000f3604260805260206080f3"; 
//web3.eth.sendTransaction({ from: account, data: bytecode }, function(err,res){console.log(res)});


//0x69602a60005260206000f3600052600a6016f3
//push10;push1 0x2a,push1 0x00 , MSTORE,push1 0x00,RETURN,push1 0x00,MSTORE,push1 0x0a,push1,AND,RETURN

MagicNumberSolution

await ethereum.request({
method: 'eth_sendTransaction',
params: [{
from: (await ethereum.request({ method: '0xd24eceF3AA9257383BD3341e63F6Cd73951186dF' }))[0], data: '0x69602a60005260206000f3600052600a6016f3'
}]
});

await contract.setSolver('上文合约部署地址');
