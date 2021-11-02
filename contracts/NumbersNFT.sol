pragma solidity >=0.7.0 <0.9.0;
// SPDX-License-Identifier: MIT

import "./Token/NFTokenMetadata.sol";
//import "./Token/NFTokenEnumerable.sol";
import "./Ownable.sol";

contract NumbersNFT is
  NFTokenMetadata,
//NFTokenEnumerable,
  Ownable{

  constructor(string memory _name,string memory _symbol)  {
    nftName = _name;
    nftSymbol = _symbol;
  }

  function mint(
    address _owner,
    uint256 _id
  )
   onlyOwner
    external
  {
    super._mint(_owner, _id);
  }

  function burn( uint256 _tokenId) onlyOwner external{
    super._burn( _tokenId);
  }

}
