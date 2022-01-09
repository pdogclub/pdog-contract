// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.4.1/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.1/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.4.1/security/Pausable.sol";
import "@openzeppelin/contracts@4.4.1/access/AccessControl.sol";
import "@openzeppelin/contracts@4.4.1/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts@4.4.1/utils/Counters.sol";

contract PopDogCards is ERC721, ERC721Enumerable, Pausable, AccessControl, ERC721Burnable {
    using Counters for Counters.Counter;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("PopDog Cards", "CARD") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/Qmb1NsTeogt6RPHnBkeHWTSUYAsojtVmUfjs7B1xJXnpR6/";
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint(address to) public onlyRole(MINTER_ROLE) {
        if(_tokenIdCounter.current() == 0){
            _tokenIdCounter.increment();
        }
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
