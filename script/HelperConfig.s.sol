//SPDX-License-Identifier: MIT

//1} deploy mocks when we are on a local anvil chain
//2} keep track of contract addresses across different chains
// example sepolia eth/usd
// eth mainnet

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";   
import{MockV3Aggregator} from "../test/mockV3Aggregrator.sol";


contract HelperConfig is Script{
//if we are on a local anvil chain, we deploy mocks
//otherwise grab existing addresses from the live network

NetworkConfig public activenetworkConfig;

uint8 public constant DECIMALS = 8;
int256 public constant INITIAL_PRICE = 2000e8;

constructor()
{
    if(block.chainid == 11155111)
    {
        activenetworkConfig = getSepoliaEthConfig();
    }
    else{
        activenetworkConfig = getOrcreateanvilEthConfig();
    }
}

struct  NetworkConfig{
    address priceFeed; //eth/usd price feed  address
}
 function getSepoliaEthConfig() public pure returns (NetworkConfig memory){
//pricefeed address
   NetworkConfig memory sepoliaconfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
 }
    
    function getOrcreateanvilEthConfig() public returns (NetworkConfig memory) {
       if(activenetworkConfig.priceFeed != address(0))
       {
              return activenetworkConfig;
       }
        
        //mocks
        vm.startBroadcast();
        MockV3Aggregator priceFeed = new MockV3Aggregator(DECIMALS,INITIAL_PRICE);

        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(priceFeed)});
        return anvilConfig;
    }
 
}
