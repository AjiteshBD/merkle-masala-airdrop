//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MasalaToken is ERC20, Ownable {
    constructor() ERC20("MasalaToken", "MTK") Ownable(msg.sender) {}

    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }
}
