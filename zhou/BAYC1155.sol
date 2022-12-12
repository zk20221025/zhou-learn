// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./40_ERC1155.sol";

contract BAYC1155 is ERC1155 {
    uint256 constant MAX_ID = 10000; 

    constructor() ERC1155("BAYC1155", "BAYC1155"){
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
    }

    function mint(address to, uint256 id, uint256 amount) external {
        require(id < MAX_ID, "id overflow");
        _mint(to, id, amount, "");
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts) external {
        for (uint256 i = 0; i < ids.length; i++) {
            require(ids[i] < MAX_ID, "id overflow");
        }
        _mintBatch(to, ids, amounts, "");
    }
}
