// SPDX-License-Identifier: MIT


pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract UJNFT is ERC721, Ownable {
    uint256 public tokenId;

    constructor() ERC721("UJNFT", "NFT") {}


    function _burn(uint256 _tokenId) internal override(ERC721) {
        super._burn(_tokenId);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        return super.tokenURI(_tokenId);
    }
}