// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MyToken is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    mapping (address => bool) mintable;
    mapping (address => bool) public isRegistered;
    mapping (address => User) public userData;
    uint constant internal eth = 10 ** 18;
    uint constant internal registerFee = 20000000000000000;

    uint256  factor;

    struct User{
        uint duration;
        uint starTime;
        uint weight;
        uint durationWeight;
        address payable superior;
        bool isLock;
        }

    constructor() ERC20("MyToken", "MTK") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        factor = 10;
    }

    function registered() external payable {
        require(msg.value == registerFee,"require 0.02 eth");
        require(isRegistered[msg.sender] == false,"already registered");
        isRegistered[msg.sender] = true;
        userData[msg.sender].weight = 1000;

    }

    function registeredWithInvitees(address payable invitees) external payable {
        require(msg.value == registerFee,"require 0.02 eth");
        require(isRegistered[invitees] == true,"invitees no registered");
        require(isRegistered[msg.sender] == false,"already registered");
        isRegistered[msg.sender] = true;
        userData[msg.sender].weight = 1000;
        userData[invitees].weight += 100;
        userData[msg.sender].starTime = block.timestamp;
        invitees.transfer(3000000000000000);
        if(userData[invitees].superior == address(0)){

        }else{
            userData[invitees].superior.transfer(2000000000000000);
        }
        userData[msg.sender].superior = invitees;


    }

    function mintOneDay() external {
        require(userData[msg.sender].isLock == false,"you are minting now");

        userData[msg.sender].isLock = true;
        userData[msg.sender].duration = 1 days;
        uint nowTime = block.timestamp;
        userData[msg.sender].starTime = nowTime;
        userData[msg.sender].durationWeight = 1;
        factor ++;

    }

    function mintOneWeek() external {
        require(userData[msg.sender].isLock == false,"you are minting now");

        userData[msg.sender].isLock = true;
        userData[msg.sender].duration = 1 weeks;
        uint nowTime = block.timestamp;
        userData[msg.sender].starTime = nowTime;
        userData[msg.sender].durationWeight = 14;
        factor ++;

    }

    function mintFourWeek() external {
        require(userData[msg.sender].isLock == false,"you are minting now");

        userData[msg.sender].isLock = true;
        userData[msg.sender].duration = 4 weeks;
        uint nowTime = block.timestamp;
        userData[msg.sender].starTime = nowTime;
        userData[msg.sender].durationWeight = 100;
        factor ++;

    }

    function mintForTest() external {
        require(userData[msg.sender].isLock == false,"you are minting now");

        userData[msg.sender].isLock = true;
        userData[msg.sender].duration = 5 seconds;
        uint nowTime = block.timestamp;
        userData[msg.sender].starTime = nowTime;
        userData[msg.sender].durationWeight = 1;
        factor ++;

    }

    function harvest() external {
        
        address user = msg.sender;
        require(userData[user].isLock == true,"not minting");
        uint nowTime = block.timestamp;
        uint interval = nowTime - userData[user].starTime;
        require(interval >= userData[user].duration,"require after duration");
        //逻辑
        uint amount = userData[user].durationWeight * userData[user].weight * eth / factor;
        _mint(msg.sender, amount);

        //收获之后
        userData[user].isLock = false;

    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }
}
