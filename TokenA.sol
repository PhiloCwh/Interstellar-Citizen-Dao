// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenA is ERC20, Ownable {
    constructor() ERC20("TokenA", "A") {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
    function approve(
        address owner,
        address spender,
        uint256 amount
    ) external returns (bool){
        _approve(owner,spender,amount);
        return true;
    }
}
