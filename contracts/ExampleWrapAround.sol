// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;


contract ExampleWrapAround {
    uint256 public  myUnit;

    uint8 public myUint8 = 2*4;

    function setMyUint(uint _myUint) public {
        myUnit = _myUint;
    }

    function decrementUint() public {
        unchecked {
            myUint8--;
        }
    }

    function increementUint() public {
        unchecked {
            myUint8++;
        }
    }

}