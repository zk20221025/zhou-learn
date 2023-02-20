// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IForta {
    function setDetectionBot(address detectionBotAddress) external;
    function notify(address user, bytes calldata msgData) external;
    function raiseAlert(address user) external;
}

contract DoubleEntryPoint {
    address  public cryptoVaultAddr ;
    function setCryptoVaultAddr(address addr) public  {
        cryptoVaultAddr = addr;
    }
    function handleTransaction(address user, bytes calldata msgData) external {
        (,,address addr) = abi.decode(msgData[4:], (address, uint256, address));
        if (addr == cryptoVaultAddr) {
            IForta(msg.sender).raiseAlert(user);
        }
    }
}