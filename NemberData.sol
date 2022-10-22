// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract NemberData {
    IERC721 ERC721 = IERC721(0xf8e81D47203A594245E36C48e151709F0C19fBe8);
    address [] private NemberList;
    mapping (address => bool) private _isNember;

    function isNember(address _nember) public view returns(bool){
        return _isNember[_nember];
    }

    function registerToNember() external {
        address user = msg.sender;//save gas
        require(ERC721.balanceOf(user) >= 1,"not NFT");
        require(_isNember[user] == false,"alreay registered");
        _isNember[user] = true;
        NemberList.push(user);
        }
    
}
