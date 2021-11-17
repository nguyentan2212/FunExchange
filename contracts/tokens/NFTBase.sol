// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "./NFTDefaultApproval.sol";

contract NFTBase is Initializable, NFTDefaultApproval, OwnableUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter internal _tokenIdCounter;

    string public baseTokenURI;
    mapping(uint256 => address) private creators;
    event Creator(uint256 tokenId, address creator);

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function setDefaultApproval(address operator, bool hasApproval) external onlyOwner{
        _setDefaultApproval(operator, hasApproval);
    }

    function creatorOf(uint256 tokenId) public view returns (address){
        return creators[tokenId];
    }

    function createdTokenOf(address creator) public view returns (uint256) {
        uint256 count = 0;
        uint256 totalItems = _tokenIdCounter.current();

        for (uint256 i = 0; i < totalItems; i++) {
            if (creators[i] == creator) {
                count += 1;
            }
        }
        return count;
    }

    function createdTokenOfCreatorByIndex(address creator, uint256 index) public view returns(uint256) {
        uint256 count = 0;
        uint256 totalItems = _tokenIdCounter.current();

        for (uint256 i = 0; i < totalItems; i++) {
            if (creators[i] == creator) {
                count += 1;
                if (count == index) {
                    return i;
                }
            }
        }
        revert("This token did not be created by this creator.");
    }

    function _saveCreator(uint256 tokenId, address creator) internal {
        creators[tokenId] = creator;

        emit Creator(tokenId, creator);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}