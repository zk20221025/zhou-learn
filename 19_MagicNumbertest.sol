pragma solidity ^0.4.11;
contract MyContract {
    uint i = (10 + 2) * 2;
}

//0x60806040526018600055348015601457600080fd5b5060358060226000396000f3006080604052600080fd00a165627a7a723058202ce9376153c7c402971d43c180f7a1c10719b27dad768bebc50b16bc07e901cf0029

//0x602a     ;PUSH1 0x2a                  v
//0x6080     ;PUSH1 0x80                  p
//0x52       ;MSTORE

//0x6020     ;PUSH1 0x20                  s
//0x6080     ;PUSH1 0x80                  p
//0xf3       ;RETURN