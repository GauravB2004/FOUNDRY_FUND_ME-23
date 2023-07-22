// SPDX-License-Identifier: MIT


pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundmeTest is Test
{
FundMe fundMe;
address USER = makeAddr("user");
uint256 constant SEND_VALUE = 0.1 ether;
uint256 constant Starting_balance = 10 ether;
uint256 constant GAS_PRICE = 1;

    
  function setUp() external{
    
 //fundMe= new FundMe(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
 DeployFundMe deployFundMe = new DeployFundMe();
 fundMe = deployFundMe.run();
 vm.deal(USER, Starting_balance);
  }
  
  
  function testminimum5dollars() public{
    assertEq(fundMe.MINIMUM_USD(),5e18);
   }
 function testOwnerthemsgsender() public
{
    assertEq(fundMe.getOwner(), msg.sender); 

}
function testPriceFeedisAccurate() public
{
    uint256 version = fundMe.getVersion();
    assertEq(version,4);
} 

function testFundfailswithoutenoughETH() public {
  vm.expectRevert();//the next line should revert
  //assert(this transaction should revert);
  fundMe.fund();
}

function testFundUpdatesFundedDatastructures() public{
  vm.prank(USER);
  fundMe.fund{value:SEND_VALUE}();
  uint256 amountFunded = fundMe.getAddresstoAmountFunded(address(USER));
  assertEq(amountFunded, SEND_VALUE);
}

function testaddfundertoarrayofFunders() public {
  vm.prank(USER);
  fundMe.fund{value: SEND_VALUE}();
  address funder = fundMe.getFunder(0);
  assertEq(funder ,USER);
}

modifier funded()
{
vm.prank(USER);
fundMe.fund{value:SEND_VALUE}();
_;
}

function testonlyownercanwithdraw() public funded {
  vm.prank(USER);
  fundMe.fund{value: SEND_VALUE}();

  vm.expectRevert();//the next line should revert
  vm.prank(USER);
  fundMe.withdraw();
}


function testWithdrawWithasingleFunder() public funded
{
  //arrange
uint256 startingOwnerBalance = fundMe.getOwner().balance;
uint256 startingFundMeBalance = address(fundMe).balance;

//act


vm.prank(fundMe.getOwner());
fundMe.withdraw();




//assert
uint256 endingOwnerBalance = fundMe.getOwner().balance;
uint256 endingFundMeBalance = address(fundMe).balance;
assertEq(endingFundMeBalance,0);
assertEq(startingFundMeBalance  + startingOwnerBalance, endingOwnerBalance);
}

function testWithdrawwithMultipleFunders() public funded
{
  //arrange
  uint160 numberofFunders =10;
  uint160 startingFundersIndex = 0;
  for(uint160 i = startingFundersIndex; i< numberofFunders ; i++)
  {
    hoax(address(i),SEND_VALUE);
    fundMe.fund{value:SEND_VALUE}();
  }

  uint256 startingOwnerBalance = fundMe.getOwner().balance;
  uint256 startingFundMeBalance = address(fundMe).balance;

  //act

  vm.startPrank(fundMe.getOwner());
  fundMe.withdraw();
  vm.stopPrank();

  //assert
  assert (address(fundMe).balance == 0);
  assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance); 
}
  
  function testWithdrawWithasingleFunderCheaper() public funded
{
  //arrange
uint256 startingOwnerBalance = fundMe.getOwner().balance;
uint256 startingFundMeBalance = address(fundMe).balance;

//act


vm.prank(fundMe.getOwner());
fundMe.CheaperWithdraw(); 




//assert
uint256 endingOwnerBalance = fundMe.getOwner().balance;
uint256 endingFundMeBalance = address(fundMe).balance;
assertEq(endingFundMeBalance,0);
assertEq(startingFundMeBalance  + startingOwnerBalance, endingOwnerBalance);
}

}