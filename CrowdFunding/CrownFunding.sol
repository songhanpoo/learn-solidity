// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {PriceConverter} from "CrowdFunding/PriceConverter.sol";

contract CrownFunding {
    using PriceConverter for uint256;
    error NoAvailableAmount();
    uint256 public MINIMUM_FUND = 5e18; // 5usd in Wei
    address public immutable i_owner;

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    constructor() {
        i_owner = msg.sender;
    }

    modifier ownerOnly() {
        if (i_owner != msg.sender) {
            revert NoAvailableAmount();
        }
        _;
    }

    function fund() public payable {
        require(
            msg.value.getConversationRate() >= MINIMUM_FUND,
            "Your amount is insufficient, at least 0.001 ether once transaction"
        );
    }

    function withdraw() public ownerOnly {
        // payable(i_owner).transfer(address(this).balance);
        (bool sent, ) = payable(i_owner).call{value: address(this).balance}("");
        require(sent, "Failed to withdraw Ethers");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
