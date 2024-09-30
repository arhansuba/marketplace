// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface INFTCollection {
    function mint() external;
    function ownerOf(uint256 tokenId) external view returns (address);
}

// INFTMarketplace.sol
pragma solidity ^0.8.0;

interface INFTMarketplace {
    function listNFT(address nftAddress, uint256 tokenId, uint256 price) external;
    function buyNFT(address nftAddress, uint256 tokenId) external payable;
}
