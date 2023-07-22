//SPDX-License-Identifier: MIT

//fund and withdraw

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import{DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/fundme.sol";

contract FundFundMe is Script{

    uint256 constant SEND_VALUE = 0.01 ether;


function fundFundMe(address mostrecentlyDeployed) public {

vm.startBroadcast();
FundMe(payable(mostrecentlyDeployed)).fund{value:SEND_VALUE}();
vm.stopBroadcast();
}
    function run ()external 
    {
        vm.startBroadcast();
        address MostrecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(MostrecentDeployed);
        vm.stopBroadcast();
    }

}

contract WithdrawFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;


function withdrawFundMe(address mostrecentlyDeployed) public {
 vm.startBroadcast();
 FundMe(payable(mostrecentlyDeployed)).withdraw();
 vm.stopBroadcast();
}
    function run () external 
    {
       
        address MostrecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(MostrecentDeployed);
       
    }
}
