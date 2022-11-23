// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Yeye {
    event Log(string msg);
    function hip() public virtual {
        emit Log ("Yeye");
    }
    function pop() public virtual {
        emit Log ("Yeye");
    }
    function yeye() public virtual {
        emit Log ("Yeye");
    }
}
contract Baba is Yeye {
    function hip() public virtual override {
        emit Log ("Baba");
    }
    function pop() public virtual override {
        emit Log ("Baba");
    }
    function baba() public virtual {
        emit Log ("Baba");
    }
}
contract Erzi is Yeye , Baba {
    function hip() public virtual override (Yeye, Baba){
        emit Log ("Erzi");
    }
    function pop() public virtual override (Yeye, Baba){
        emit Log ("Erzi");
    }
}
contract Base1 {
    modifier exactDivideBy2And3(uint _a) virtual {
        require(_a % 2 == 0 && _a % 3 == 0 );
        _;
    }
}
contract Identifier is Base1 {
    function getExactDivideBy2And3(uint _dividend) public exactDivideBy2And3(_dividend) pure returns(uint, uint) {
        return getExactDivideBy2And3WithoutModifier(_dividend);
    } 
    function getExactDivideBy2And3WithoutModifier(uint _dividend) public pure returns (uint, uint) {
        uint div2 = _dividend / 2;
        uint div3 = _dividend / 3;
        return (div2, div3);
    }
    modifier exactDivideBy2And3(uint _a) override {
        _;
        require ( _a % 2 == 0 && _a % 3 == 0 );
    }
}