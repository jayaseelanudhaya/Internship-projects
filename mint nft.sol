// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFTMintingContract {
    // Store the address of the current NFT contract
    address private nftContract;

    // Mapping to keep track of already minted NFTs
    mapping(uint256 => bool) private mintedTokens;

    // Event to be emitted when an NFT is minted
    event NFTMinted(address indexed owner, uint256 indexed tokenId);

    // Function to set the address of the NFT contract
    function setNFTContract(address _nftContract) external {
        // Perform any necessary validations, e.g., check if the sender is authorized to set the contract
        nftContract = _nftContract;
    }

    // Function to mint an NFT
    function mintNFT(uint256 _tokenId) external {
        // Ensure the NFT contract address is set
        require(nftContract != address(0), "NFT contract address not set");

        // Check if the token has already been minted
        require(!mintedTokens[_tokenId], "Token already minted");

        // Mark the token as minted
        mintedTokens[_tokenId] = true;

        // Emit the event
        emit NFTMinted(msg.sender, _tokenId);
    }
}
