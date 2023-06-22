//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Kangaroo is ERC1155, Ownable {
    mapping(uint256 => string) public tokenURI;
    uint256 public tokenId;

    constructor() ERC1155("") {}

    function mint(
        uint256 amount,
        string memory _tokenURI,
        bytes memory data
    ) public returns (uint256) {
        uint256 _tokenId = tokenId;
        tokenURI[_tokenId] = _tokenURI;
        _mint(msg.sender, _tokenId, amount, data);
        tokenId++;
        return _tokenId;
    }

    function uri(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        return tokenURI[_tokenId];
    }
}