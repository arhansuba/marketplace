// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RoyaltyManager {
    struct Royalty {
        address recipient;
        uint256 amount; // in basis points (e.g., 500 for 5%)
    }

    mapping(uint256 => Royalty) public royalties;

    function setRoyalty(uint256 tokenId, address recipient, uint256 amount) external {
        // Logic for only the owner of the NFT to set royalties
        royalties[tokenId] = Royalty(recipient, amount);
    }

    function getRoyalty(uint256 tokenId) external view returns (Royalty memory) {
        return royalties[tokenId];
    }
}
