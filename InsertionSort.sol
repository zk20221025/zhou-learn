// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract InsertionSort {
    function ifElseTest(uint256 _number) public pure returns(bool){
        if (_number == 0){
            return(true);
        }else {
            return(false);
        }
    }
    function forLoopTest() public pure returns(uint256){
        uint sum = 0;
        for(uint i = 0 ; i < 10 ; i++){
            sum += i;
        }
        return(sum);
    }
    function whileTest() public pure returns(uint256){
        uint sum = 0;
        uint i = 0;
        while(i<10){
            sum += i;
            i++;
        }
        return(sum);
    }
    function doWhileTest() public pure returns(uint256){
        
    }
}