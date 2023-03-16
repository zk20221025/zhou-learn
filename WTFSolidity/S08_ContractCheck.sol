// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ContractCheck is ERC20 {
    constructor() ERC20("", "") {}

    function isContract(address account) public view returns (bool) {
        uint size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function mint() public {
        require(!isContract(msg.sender), "Contract not allowed!");
        _mint(msg.sender, 100);
    }
}

contract NotContract {
    bool public isContract;
    address public contractCheck;

    constructor(address addr) {
        contractCheck = addr;
        isContract = ContractCheck(addr).isContract(address(this));

        for(uint i; i < 10; i++){
            ContractCheck(addr).mint();
        }
    }

    function mint() external {
        ContractCheck(contractCheck).mint();
    }
}