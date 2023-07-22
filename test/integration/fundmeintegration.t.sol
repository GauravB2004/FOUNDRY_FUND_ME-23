// SPDX-License-Identifier: MIT


pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import{FundFundMe , WithdrawFundMe} from "../../script/Interactions.s.sol";

contract FundmeTestIntegration is Test
{
FundMe fundMe;
address USER = makeAddr("user");
uint256 constant SEND_VALUE = 0.1 ether;
uint256 constant Starting_balance = 10 ether;
uint256 constant GAS_PRICE = 1; 


    function setUp() external{
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, Starting_balance);
    }

    function testUsercanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
}
    }
