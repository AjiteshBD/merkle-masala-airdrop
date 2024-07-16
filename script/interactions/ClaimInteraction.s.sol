//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {CodeConstant} from "../utils/CodeConstant.s.sol";

contract ClaimInteraction is Script, CodeConstant {
    error ClaimInteraction__InvalidSignatureLength();

    function claim(address merkleAirdrop) public {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(SIGNATURE);
        vm.startBroadcast();
        MerkleAirdrop(merkleAirdrop).claim(CLAIMER, AMOUT_TO_CLAIM, PROOF, v, r, s);
        vm.stopBroadcast();
    }

    function splitSignature(bytes memory signature) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
        if (signature.length != 65) {
            revert ClaimInteraction__InvalidSignatureLength();
        }
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }
        return (v, r, s);
    }

    function run() public {
        address merkleAirdrop = DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid);
        claim(merkleAirdrop);
    }
}
