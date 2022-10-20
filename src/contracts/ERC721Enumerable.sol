// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';



contract ERC721Enumerable is IERC721Enumerable, ERC721 {

    uint256[] private _allTokens;

    // mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    // mapping of owner => list of all owned token ids
    mapping(address => uint256[]) private _ownedTokens;

    // mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) _ownedTokenIndex;

    constructor () {
        _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^keccak256('tokenByIndex(bytes4)')^keccak256('tokenOfOwnerByIndex(bytes4)')));
    }
 
    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        // 2 things! 
        // A. Add tokens to the owner;
        // B. All tokens to our totalsupply - to all Tokens
        _addTokensToAllTokenEnumeration(tokenId);
        _addTokenstoOwnerEnumeration(to, tokenId);
    }

    function tokenByIndex(uint256 _index) external override view returns (uint256){
        require(_index < totalSupply(), 'global index is out of bounds');
        return _allTokensIndex[_index];
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _index) external override view returns (uint256){
        require(_index < balanceOf(_owner), 'owner index is out of bounds');
        return _ownedTokens[_owner][_index];
    }

    // return the total supply of the _allTokens array
    function totalSupply() public override view returns (uint256) {
        return _allTokens.length;
    }

    // add tokens to the _alltokens array and set the position of the token in the array
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokenstoOwnerEnumeration(address to, uint256 tokenId) private {
        // 1. Add address and token id to the _ownedTokens
        // 2. ownedTokensIdex tokenId set to the address of ownedTokens position
        // 3. execute this function with minting 
         _ownedTokenIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }
}