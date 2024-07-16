//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../../src/MerkleAirdrop.sol";
import {MasalaToken} from "../../src/MasalaToken.sol";
import {DeployMerkleAirdrop} from "script/deploy/DeployMerkleAirdrop.s.sol";
import {ZkSyncChainChecker} from "foundry-devops/src/ZkSyncChainChecker.sol";
import {CodeConstant} from "script/utils/CodeConstant.s.sol";

contract MerkleTest is Test, CodeConstant, ZkSyncChainChecker {
    MerkleAirdrop merkleAirdrop;
    MasalaToken masalaToken;
    address USER;
    uint256 PRIVATE;
    address GASPAYER;

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
        GASPAYER = makeAddr("GASPAYER");
    }

    function testClaim() public {
        uint256 userbalance = masalaToken.balanceOf(USER);
        bytes32 digest = merkleAirdrop.getMessageHash(USER, AMOUT_TO_CLAIM);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(PRIVATE, digest);
        vm.prank(GASPAYER);
        merkleAirdrop.claim(USER, AMOUT_TO_CLAIM, PROOF, v, r, s);
        assertEq(masalaToken.balanceOf(USER), userbalance + AMOUT_TO_CLAIM);
    }
}
