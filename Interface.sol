// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface INemberData {
    function isNember(address _nember) external view returns(bool);
    
}
