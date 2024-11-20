// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {PriceConverter} from "CrowdFunding/PriceConverter.sol";

contract CrownFunding {
    using PriceConverter for uint256;
    error NoAvailableAmount();
    uint256 public MINIMUM_FUND = 5e18; // 5usd in Wei
    address public immutable i_owner;

    mapping(address funder => bool isFunded) public isFunders;
    mapping(address funder => uint256 value) public funderToAmount;
    address[] public funders;

    event Funded(address indexed funder, uint256 value);
    event Withdraw(address indexed owner, uint256 value);

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

        funderToAmount[msg.sender] += msg.value;
        bool isFundded = isFunders[msg.sender];
        if(!isFundded) {
            funders.push(msg.sender);
            isFunders[msg.sender] = true;
        }
        emit Funded(msg.sender, msg.value);
    }

    function withdraw() public ownerOnly {
        

        // funders = new address[](0);

        (bool sent, ) = payable(i_owner).call{value: address(this).balance}("");
        require(sent, "Failed to withdraw Ethers");
        emit Withdraw(i_owner, address(this).balance);
        // delete  funders
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getNumberOfFunders() public  view returns(uint256) {
        return funders.length;
    }
}
