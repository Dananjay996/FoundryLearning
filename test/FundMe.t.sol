// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "../lib/forge-std/src/Test.sol";
import {console} from "../lib/forge-std/src/console.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test{
    FundMe fundme;
    address private USER = makeAddr("user");
    uint256 private STARTING_BALANCE = 10 ether;
    uint256 private SEND_AMOUNT = 1 ether;

    function setUp() external {
        DeployFundMe deploy =  new DeployFundMe();
        fundme = deploy.run();
        console.log(address(this));
        console.log(msg.sender);
        console.log(fundme.i_owner());
        // send ether to user address
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumUSD() external {
        assertEq(5 * 10 ** 18, fundme.MINIMUM_USD());
    }

    function testPriceFeedVersionIsAccurate() external {
        uint256 version = fundme.getVersion();
        assertEq(version, 4);
    }
    
    function testFundFunction() external {
        vm.prank(USER);
        fundme.fund{value: SEND_AMOUNT}();
        console.log(fundme.valueAfterFunded()/1e18);
        assertEq(fundme.addressToAmountFunded(USER), SEND_AMOUNT);
    }

    function testWithdrawFunction() external {
        vm.prank(USER);
        fundme.fund{value: SEND_AMOUNT}();
        
        // withdraw from USER address
        vm.expectRevert();
        fundme.withdraw();

        vm.prank(fundme.i_owner());
        // Withdraw from owner address
        fundme.withdraw();

    }
}
