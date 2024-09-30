// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NFTMarketplace is ERC721Enumerable, Ownable {
    using Strings for uint256; // Use Strings for uint256

    string private baseTokenURI;
    uint256 public nextTokenId;

    // Marketplace related structures
    struct Listing {
        address seller;
        uint256 price;
    }

    mapping(uint256 => Listing) public listings; // TokenId to Listing
    mapping(address => uint256[]) public stakedTokens; // User address to staked tokens

    constructor(
        string memory name, 
        string memory symbol, 
        string memory _baseTokenURI
    ) 
        ERC721(name, symbol) // Pass parameters to ERC721 constructor
        Ownable(msg.sender) // Call to Ownable constructor
    { 
        baseTokenURI = _baseTokenURI;
        nextTokenId = 0; // Initialize nextTokenId
    }

    // Minting NFTs
    function mint() external onlyOwner {
        _safeMint(msg.sender, nextTokenId);
        nextTokenId++;
    }

    // Listing NFTs for sale
    function listNFT(uint256 tokenId, uint256 price) external {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        require(price > 0, "Price must be greater than zero");
        
        listings[tokenId] = Listing(msg.sender, price);
    }

    // Buying NFTs
    function buyNFT(uint256 tokenId) external payable {
        Listing memory listing = listings[tokenId];
        require(listing.price > 0, "NFT not listed");
        require(msg.value >= listing.price, "Insufficient funds");

        // Transfer NFT from seller to buyer
        transferFrom(listing.seller, msg.sender, tokenId);
        payable(listing.seller).transfer(msg.value);

        // Remove the listing
        delete listings[tokenId];
    }

    // Staking functionality
    function stake(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        transferFrom(msg.sender, address(this), tokenId); // Transfer NFT to this contract
        stakedTokens[msg.sender].push(tokenId); // Record the staked token
    }

    function unstake(uint256 tokenId) external {
        require(isStaked(msg.sender, tokenId), "Token not staked");
        transferFrom(address(this), msg.sender, tokenId); // Transfer NFT back to the user

        // Remove token from stakedTokens
        removeStakedToken(msg.sender, tokenId);
    }

    function isStaked(address user, uint256 tokenId) internal view returns (bool) {
        uint256[] storage userStakedTokens = stakedTokens[user];
        for (uint256 i = 0; i < userStakedTokens.length; i++) {
            if (userStakedTokens[i] == tokenId) {
                return true; // Token is staked
            }
        }
        return false; // Token is not staked
    }

    function removeStakedToken(address user, uint256 tokenId) internal {
        uint256[] storage userStakedTokens = stakedTokens[user];
        for (uint256 i = 0; i < userStakedTokens.length; i++) {
            if (userStakedTokens[i] == tokenId) {
                userStakedTokens[i] = userStakedTokens[userStakedTokens.length - 1]; // Replace with the last element
                userStakedTokens.pop(); // Remove the last element
                break;
            }
        }
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }
}
