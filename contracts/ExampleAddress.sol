// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;


contract ExampleAddress {
    address public someAddress;

    function setSomeAddress(address _someAddress) public {
        someAddress = _someAddress;
    }

    function getBalance() public view returns(uint) {
        return someAddress.balance;
    }
}