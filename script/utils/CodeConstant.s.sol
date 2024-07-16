//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract CodeConstant {
    bytes32 public constant ROOT = 0x7cdb6c21ef22a6cb5726d348e677f3e10032127425d425c5028965a30a71556e;
    uint256 AMOUT_TO_CLAIM = 25 * 1e18;
    uint256 MINT_AMOUNT = 4 * AMOUT_TO_CLAIM;
    bytes32 private FIRST_PROOF = 0x72995a443d90c829031cb42be582996fb8747dc02130f358dba0ad65c8db5119;
    bytes32 private SECOND_PROOF = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public PROOF = [FIRST_PROOF, SECOND_PROOF];
    address public constant CLAIMER = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    bytes internal constant SIGNATURE =
        hex"677fb64b70cb7c328c31fcf5e39506faef0f3d04a29e5bbe315f4cf65719920042f84925d77117e28d04bafbcd08bdb1decda2d6c8dc486880fa04c91b5f35d61c";
}
