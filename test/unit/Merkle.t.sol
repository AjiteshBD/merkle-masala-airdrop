//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../../src/MerkleAirdrop.sol";
import {MasalaToken} from "../../src/MasalaToken.sol";
import {CodeConstant, DeployMerkleAirdrop} from "script/deploy/DeployMerkleAirdrop.s.sol";
import {ZkSyncChainChecker} from "foundry-devops/src/ZkSyncChainChecker.sol";

contract MerkleTest is Test, CodeConstant, ZkSyncChainChecker {
    MerkleAirdrop merkleAirdrop;
    MasalaToken masalaToken;
    address USER;
    uint256 PRIVATE;

    bytes32 private FIRST_PROOF = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 private SECOND_PROOF = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public PROOF = [FIRST_PROOF, SECOND_PROOF];

    function setUp() public {
        if (!isZkSyncChain()) {
            DeployMerkleAirdrop deployer = new DeployMerkleAirdrop();
            (masalaToken, merkleAirdrop) = deployer.run();
        } else {
            masalaToken = new MasalaToken();
            merkleAirdrop = new MerkleAirdrop(masalaToken, ROOT);
            masalaToken.mint(masalaToken.owner(), MINT_AMOUNT);
            masalaToken.transfer(address(merkleAirdrop), MINT_AMOUNT);
        }
        (USER, PRIVATE) = makeAddrAndKey("USER");
    }

    function testClaim() public {
        uint256 userbalance = masalaToken.balanceOf(USER);
        console.log(USER);
        vm.prank(USER);
        merkleAirdrop.claim(USER, AMOUT_TO_CLAIM, PROOF);
        assertEq(masalaToken.balanceOf(USER), userbalance + AMOUT_TO_CLAIM);
    }
}
