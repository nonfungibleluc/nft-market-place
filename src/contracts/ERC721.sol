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
    
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId);

    // mapping in solidity creates a hash table of key pair values

    // Mapping from token id to the owner
    mapping(uint => address) private _tokenOwner;

    //Mapping from owner to number of owned tokens
    mapping(address => uint) private _ownedTokensCount;

    // Mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    // Count all NFTs assigned to an owner
    function balanceOf(address _owner) public view returns(uint256) {
        require(_owner != address(0), 'ERC721: Owner query for non-existant token');
        return _ownedTokensCount[_owner];
    }

    // Find the Owner of a token
    function ownerOf(uint256 _tokenId) public view returns(address){
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'ERC721: Owner query for non-existant token');
        return owner;
    }

    function _exists(uint tokenId) internal view returns(bool){
        // setting the addresss of the nft owner to check the mapping
        // of the address from tokenOwner at the tokenId;
        address owner = _tokenOwner[tokenId];
        // return truthiness
        return owner != address(0);
    }

    function _mint(address _to, uint _tokenId) internal virtual {
        // requires that the address isn't zero
        require(_to != address(0), 'ERC721: minting to the zero address');
        // requires that the token does not already exist
        require(!_exists(_tokenId), 'ERC721: token already minted');
        // adding the new address with a token id for minting
        _tokenOwner[_tokenId] = _to;
        // Keeping track of each address that is minting and adding one to the count
        _ownedTokensCount[_to] += 1;

        emit Transfer(address(0), _to, _tokenId);
    }

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to "".
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer

    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), 'Error - ERC721 Transfer to the zero address');
        require(_from == ownerOf(_tokenId), 'Error - ERC721 Trying to transfer a token the address does not own');
        require(isApprovedOrOwner(msg.sender, _tokenId));

        // Update Token Counts
        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;

        // Change token owner
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        _transferFrom(_from, _to, _tokenId);
    }

    // 1. require that the person approving is the owner
    // 2. approve an address to a token (tokenId)
    // 3. require that we can't approve sending tokens of the owner to the current caller
    // 4. update the map of the approval addresses
    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, 'Error - approval to current owner');
        require(msg.sender == owner, 'Current caller is not the owner of the token');

        _tokenApprovals[tokenId] == _to;

        emit Approval(owner, _to, tokenId);
    }

    // This is not a complete approval function
    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId), 'token does not exist');
        address owner = ownerOf(tokenId);
        return(spender == owner);
    }
}