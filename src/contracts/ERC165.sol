// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/IERC165.sol';

contract ERC165 is IERC165 {

    // has table to keep track of contract fingerprint data of byte function conversions
    mapping(bytes4 => bool) private _supportedInterfaces;

    function supportsInterface(bytes4 interfaceID) external view returns (bool){
        return _supportedInterfaces[interfaceID];
    }

    constructor () {
        _registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
    }

    // register the interface (comes from within)
    function _registerInterface(bytes4 interfaceID) internal {
        require(interfaceID != 0xffffffff, "ERC165: Invalid Interface");
        _supportedInterfaces[interfaceID] = true;
    }

}