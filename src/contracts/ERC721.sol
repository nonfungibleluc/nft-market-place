// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

    /*

    building out the minting function
        a. nft to point to an address
        b. keep track of the token IDs
        c. keep tract of token owner addresses to token ids
        d. keep track of how many tokens an owner address has
        e. create an event that emits a transfer log - contract address, where it is being minted to, the id

    */

contract ERC721 {

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId);

    // mapping in solidity creates a hash table of key pair values

    // Mapping from token id to the owner
    mapping(uint => address) private _tokenOwner;

    //Mapping from owner to number of owned tokens
    mapping(address => uint) private _ownedTokensCount;

    function _exists(uint tokenId) internal view returns(bool){
        // setting the addresss of the nft owner to check the mapping
        // of the address from tokenOwner at the tokenId;
        address owner = _tokenOwner[tokenId];
        // return truthiness
        return owner != address(0);
    }

    function _mint(address to, uint tokenId) internal {
        // requires that the address isn't zero
        require(to != address(0), 'ERC721: minting to the zero address');
        // requires that the token does not already exist
        require(!_exists(tokenId), 'ERC721: token already minted');
        // adding the new address with a token id for minting
        _tokenOwner[tokenId] = to;
        // Keeping track of each address that is minting and adding one to the count
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

}