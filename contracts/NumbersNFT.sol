// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./Token/NFTokenMetadata.sol";
//import "./Token/NFTokenEnumerable.sol";
import "./Ownable.sol";

contract NumbersNFT is
  NFTokenMetadata,

  Ownable{

  constructor(string memory _name,string memory _symbol)  {       
    nftName = _name;
    nftSymbol = _symbol;
  }

  function mint(address _owner,uint256 _id) onlyOwner external{   //铸造NFT
    super._mint(_owner, _id);
  }

  function burn( uint256 _tokenId) onlyOwner external{            //烧毁NFT
    super._burn( _tokenId);
  }

}
