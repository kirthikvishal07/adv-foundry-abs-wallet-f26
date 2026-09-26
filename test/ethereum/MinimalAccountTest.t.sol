// //SPDX-License-Identifier: MIT
// pragma solidity ^0.8.28;

// import {Test} from "forge-std/Test.sol";
// import {HelperConfig} from "script/HelperConfig.s.sol";
// import {DeployMinimal} from "script/DeployMinimal.s.sol";
// import {MinimalAccount} from "src/ethereum/MinimalAccount.sol";
// import {SendPackedUserOp, PackedUserOperation,IEntryPoint} from "script/SendPackedUserOp.s.sol";
// import {ECDSA} from "lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
// import {ERC20Mock} from "lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";
// import {MessageHashUtils} from "lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";

// contract MinimalAccountTest is Test {
//     using MessageHashUtils for bytes32;
//     HelperConfig helperConfig;
//     MinimalAccount minimalAccount;
//     ERC20Mock usdc;
//     SendPackedUserOp sendPackedUserOp;

//     address randomUser = makeAddr("user");

//     uint256 constant AMOUNT = 1e18;

//     function setUp() public {
//         DeployMinimal deployMinimal = new DeployMinimal();
//         (helperConfig, minimalAccount) = deployMinimal.deployMinimalAccount();
//         usdc = new ERC20Mock();
//         sendPackedUserOp = new SendPackedUserOp();
//     }

//     function testOwnerCanExecuteCommands() public {
//         //Arrange
//         assertEq(usdc.balanceOf(address(minimalAccount)), 0);
//         address dest = address(usdc);
//         uint256 value = 0;
//         bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector, address(minimalAccount), AMOUNT);
//         //Act
//         vm.prank(minimalAccount.owner());
//         minimalAccount.execute(dest, value, functionData);
//         //Assert
//         assertEq(usdc.balanceOf(address(minimalAccount)), AMOUNT);
//     }

//     function testNonOwnerCannotExecuteCommands() public {
//         //Arrange
//         assertEq(usdc.balanceOf(address(minimalAccount)), 0);
//         address dest = address(usdc);
//         uint256 value = 0;
//         bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector, address(minimalAccount), AMOUNT);
//         //Act
//         vm.prank(randomUser);
//         vm.expectRevert(MinimalAccount.MinimalAccount__NotFromEntryPointOrOwner.selector);
//         minimalAccount.execute(dest, value, functionData);
//         //Assert
//         // assertEq(usdc.balanceOf(address(minimalAccount)),AMOUNT);
//     }

//     function testRecoverSignedOp() public  {
//         //arrange
//         assertEq(usdc.balanceOf(address(minimalAccount)), 0);
//         address dest = address(usdc);
//         uint256 value = 0;
//         bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector, address(minimalAccount), AMOUNT);
//         bytes memory executeCallData = abi.encodeWithSelector(MinimalAccount.execute.selector,dest,value,functionData);
//         PackedUserOperation memory packedUserOp = sendPackedUserOp.generatedSignedUserOperation(executeCallData,helperConfig.getConfig(),address(minimalAccount));
//         bytes32 userOperationHash = IEntryPoint(helperConfig.getConfig().entryPoint).getUserOpHash(packedUserOp);
//         //act
//         address actualSigner = ECDSA.recover(userOperationHash.toEthSignedMessageHash(),packedUserOp.signature);

//         //assert 20:00
//         assertEq(actualSigner,minimalAccount.owner());
//     }

//     //1 SIGN USER OPS
//     //2 CALL VALIDATE USRE OPS
//     //3 ASSERT THE RETURN IS CORRECT
//     function testValidationOfUserOps() public{
//         //arrange
//         assertEq(usdc.balanceOf(address(minimalAccount)), 0);
//         address dest = address(usdc);
//         uint256 value = 0;
//         bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector, address(minimalAccount), AMOUNT);
//         bytes memory executeCallData = abi.encodeWithSelector(MinimalAccount.execute.selector,dest,value,functionData);
//         PackedUserOperation memory packedUserOp = sendPackedUserOp.generatedSignedUserOperation(executeCallData,helperConfig.getConfig(),address(minimalAccount));
//         bytes32 userOperationHash = IEntryPoint(helperConfig.getConfig().entryPoint).getUserOpHash(packedUserOp);
//         uint256 missingAccountFunds = 1e18;

//         vm.prank(helperConfig.getConfig().entryPoint);
//         uint256 validationData = minimalAccount.validateUserOp(packedUserOp,userOperationHash,missingAccountFunds);

//         //act
//         assertEq(validationData,0);
//     }

//     function testEntryPointCanExecuteCommands() public {
//         //arrange
//         assertEq(usdc.balanceOf(address(minimalAccount)), 0);
//         address dest = address(usdc);
//         uint256 value = 0;
//         bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector, address(minimalAccount), AMOUNT);
//         bytes memory executeCallData = abi.encodeWithSelector(MinimalAccount.execute.selector,dest,value,functionData);
//         PackedUserOperation memory packedUserOp = sendPackedUserOp.generatedSignedUserOperation(executeCallData,helperConfig.getConfig(),address(minimalAccount));
//         // bytes32 userOperationHash = IEntryPoint(helperConfig.getConfig().entryPoint).getUserOpHash(packedUserOp);

//         vm.deal(address(minimalAccount),1e18);

//         PackedUserOperation[] memory ops = new PackedUserOperation[](1);
//         ops[0] = packedUserOp;

//         //act
//         // vm.startPrank(randomUser);
//         // IEntryPoint(helperConfig.getConfig().entryPoint).handleOps(ops,payable(randomUser));
//         address defaultTxOriginAddress = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;

//         vm.startPrank(randomUser);
//         IEntryPoint(helperConfig.getConfig().entryPoint).handleOps(ops, payable(defaultTxOriginAddress));
//         vm.stopPrank();

//         //assert
//         assertEq(usdc.balanceOf(address(minimalAccount)), AMOUNT);
//     }
// }
