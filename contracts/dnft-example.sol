// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@klaytn/contracts/KIP/token/KIP17/KIP17.sol";
import "@klaytn/contracts/KIP/token/KIP17/extensions/KIP17Enumerable.sol";
import "@klaytn/contracts/KIP/token/KIP17/extensions/KIP17URIStorage.sol";
import "@klaytn/contracts/utils/Counters.sol";
import "@klaytn/contracts/utils/Strings.sol";
import "@klaytn/contracts/access/Ownable.sol";


contract KdynamicNFT is KIP17, KIP17Enumerable, KIP17URIStorage, Ownable {
    using Counters for Counters.Counter;

     Counters.Counter private _tokenIdCounter;
     mapping(uint256 => uint) _experienceMap;

    // IPFS URIs for the dynamic nft graphics/metadata.
    // NOTE: These connect to my IPFS Companion node.
    // You should upload the contents of the /ipfs folder to your own node for development.
    string _level20 = "https://github.com/kjeom/dNFTExample/asset/metadata/level20.json";
    string _level50 = "https://github.com/kjeom/dNFTExample/asset/metadata/level50.json";
    string _level80 = "https://github.com/kjeom/dNFTExample/asset/metadata/level80.json";

    event TokensUpdated(uint level);

    constructor() KIP17("Klaytn dNFT", "KDNFT") {}

    function safeMint(address to) public  {
        // Current counter value will be the minted token's token ID.
        uint256 tokenId = _tokenIdCounter.current();

        // Increment it so next time it's correct when we call .current()
        _tokenIdCounter.increment();

        // Mint the token
        _safeMint(to, tokenId);

        // Initialize experience
        _experienceMap[tokenId] = 0;

        // Default to a bull NFT
        string memory defaultUri = _level20;
        _setTokenURI(tokenId, defaultUri);
    }

    function hunt(string calldata mob) external  {
        if (_compareStrings(mob, "ant")) {
            updateExperience(25);
        } else if (_compareStrings(mob, "spider")) {
            updateExperience(500);
        }
    }

    function updateExperience(uint experience) internal {
        uint256 tokenId = _tokenIdCounter.current();
        _experienceMap[tokenId] += experience;
        if (_experienceMap[tokenId] > 1000) {
            // level 80
            _setTokenURI(tokenId, _level80);
            emit TokensUpdated(80);
        } else if (_experienceMap[tokenId] > 50) {
            // level 50
            _setTokenURI(tokenId, _level50);
            emit TokensUpdated(50);
        } else {
            // level 0
            emit TokensUpdated(0);
        }
    }

    function _compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
    
    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(KIP17, KIP17Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(KIP17, KIP17URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(KIP17, KIP17URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(KIP17, KIP17Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}