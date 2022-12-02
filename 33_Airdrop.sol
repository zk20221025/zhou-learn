// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "31_ERC20.sol";

contract Airdrop {

    function getSum(uint256[] calldata _arr) public pure returns(uint sum) {
        for (uint i = 0; i < _arr.length; i++)
            sum = sum + _arr[i];
    }

    function multTransferToken(
        address _token,
        address[] calldata _addresses,
        uint256[] calldata _amounts
    ) external {
        require(_addresses.length == _amounts.length , "Lengths of Addresses and Amounts NOT EQUAL");
        IERC20 token = IERC20(_token);
        uint _amountSum = getSum(_amounts);
        require(token.allowance(msg.sender , address(this)) > _amountSum , "Need Approve ERC20 token");

        for (uint256 i; i < _addresses.length; i++) {
            token.transferFrom(msg.sender , _addresses[i] , _amounts[i]);
        }
    }

    function multTransferETH (
        address payable[] calldata _addresses,
        uint256[] calldata _amounts
    ) public payable {
        require (_addresses.length == _amounts.length , "Lengths of Addresses and Amounts NOT EQUAL");
        for(uint256 i = 0; i < _addresses.length; i++) {
            _addresses[i].transfer(_amounts[i]);
        }
    }
}