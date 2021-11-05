// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "./Token/NFToken.sol";
import "./Token/ERC721.sol";

contract ETH_Auction{
    address payable manager;
    address payable[] public players;
    uint256 public round;
    address payable public winner;
    
    ERC721 public NFTContract;
    uint64 public auctionId; // max is 18446744073709551615
    
      struct Auction {
      uint64    id;
      address   seller;
      uint256   tokenId;
      uint128   startingPrice;  // wei
      uint128   endingPrice;    // wei
      uint64    duration;       // seconds
      uint64    startedAt;      // time
  }
    
    constructor(address _NFTAddress)  {       
       NFTContract = ERC721(_NFTAddress); 
    }
    
    event AuctionCreated(uint64 auctionId, uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
    event AuctionCancelled(uint64 auctionId, uint256 tokenId);
    event AuctionSuccessful(uint64 auctionId, uint256 tokenId, uint256 totalPrice, address winner);
    
     mapping (uint256 => Auction) internal tokenIdToAuction;
    mapping (uint64 => Auction) internal auctionIdToAuction;
    
    
    function createAuction(
      uint256 _tokenId, uint256 _startingPrice,
      uint256 _endingPrice, uint256 _duration) public {
    
      require(_startingPrice < 340282366920938463463374607431768211455);        // 128 bits,保证小于最大值
      require(_endingPrice < 340282366920938463463374607431768211455);          // 128 bits
      require(_duration <= 18446744073709551615 && _duration >= 30 seconds);    // 64 bits
      require(NFTContract.ownerOf(_tokenId) == msg.sender);

      Auction memory auction = Auction(
          uint64(auctionId),
          msg.sender,
          uint256(_tokenId),
          uint128(_startingPrice),
          uint128(_endingPrice),
          uint64(_duration),
          uint64(block.timestamp)
      );

      tokenIdToAuction[_tokenId] = auction;
      auctionIdToAuction[auctionId] = auction;

      emit AuctionCreated(  
          uint64(auctionId),
          uint256(_tokenId),
          uint256(auction.startingPrice),
          uint256(auction.endingPrice),
          uint256(auction.duration)
      );

      auctionId++;
  }

  function getAuctionByAuctionId(uint64 _auctionId) public view returns (       //通过拍卖事件的ID来获取拍卖事件
      uint64 id,
      address seller,
      uint256 tokenId,
      uint256 startingPrice,
      uint256 endingPrice,
      uint256 duration,
      uint256 startedAt
  ) {
      Auction storage auction = auctionIdToAuction[_auctionId];
      require(auction.startedAt > 0);
      return (
          auction.id,
          auction.seller,
          auction.tokenId,
          auction.startingPrice,
          auction.endingPrice,
          auction.duration,
          auction.startedAt
      );
  }

  function getAuctionByTokenId(uint256 _tokenId) public view returns (          //通过NFT的ID来获取拍卖事件
      uint64 id,
      address seller,
      uint256 tokenId,
      uint256 startingPrice,
      uint256 endingPrice,
      uint256 duration,
      uint256 startedAt
  ) {
      Auction storage auction = tokenIdToAuction[_tokenId];
      require(auction.startedAt > 0);
      return (
          auction.id,
          auction.seller,
          auction.tokenId,
          auction.startingPrice,
          auction.endingPrice,
          auction.duration,
          auction.startedAt
      );
  }

  function cancelAuctionByAuctionId(uint64 _auctionId) public {             //通过拍卖事件的ID来取消拍卖事件
      Auction storage auction = auctionIdToAuction[_auctionId];

      require(auction.startedAt > 0);
      require(msg.sender == auction.seller);

      delete auctionIdToAuction[_auctionId];
      delete tokenIdToAuction[auction.tokenId];

      emit AuctionCancelled(_auctionId, auction.tokenId);
  }

  function cancelAuctionByTokenId(uint256 _tokenId) public {                //通过NFT的ID来取消拍卖事件
      Auction storage auction = tokenIdToAuction[_tokenId];

      require(auction.startedAt > 0);
      require(msg.sender == auction.seller);

      delete auctionIdToAuction[auction.id];
      delete tokenIdToAuction[_tokenId];

      emit AuctionCancelled(auction.id, auction.tokenId);
  }

  function bid(uint256 _tokenId) public payable {                           //中标
      Auction storage auction = tokenIdToAuction[_tokenId];
      require(auction.startedAt > 0);

      uint256 price = getCurrentPrice(auction);                             //如果价高，则当前拍卖价格改为该竞价
      require(msg.value >= price);

      address seller = auction.seller;
      uint64 auctionId_temp = auction.id;

      delete tokenIdToAuction[_tokenId];
      delete auctionIdToAuction[auction.id];

      if (price > 0) {
          uint256 sellerProceeds = price;
          payable(seller).transfer(sellerProceeds);                         //拍卖者获得收入
      }

      NFTContract.transferFrom(seller, msg.sender, _tokenId);               //NFT的所有权转移  

      emit AuctionSuccessful(auctionId_temp, _tokenId, price, msg.sender);
  }

  function getCurrentPriceByAuctionId(uint64 _auctionId) public view returns (uint256) { //通过拍卖事件ID获取当前竞拍价格
      Auction storage auction = auctionIdToAuction[_auctionId];
      return getCurrentPrice(auction);
  }

  function getCurrentPriceByTokenId(uint256 _tokenId) public view returns (uint256) {   //通过NFT的ID获取当前竞拍价格
      Auction storage auction = tokenIdToAuction[_tokenId];
      return getCurrentPrice(auction);
  }

  function getCurrentPrice(Auction storage _auction) internal view returns (uint256) {  
      require(_auction.startedAt > 0);
      uint256 secondsPassed = 0;

      secondsPassed = block.timestamp - _auction.startedAt;

      if (secondsPassed >= _auction.duration) {     //如果超过了规定的拍卖时间，则返回最后的竞拍价格
          return _auction.endingPrice;
      } else {
        //   int256 totalPriceChange = int256(_auction.endingPrice) - int256(_auction.startingPrice);
        //   int256 currentPriceChange = totalPriceChange * int256(secondsPassed) / int256(_auction.duration);
        //   int256 currentPrice = int256(_auction.startingPrice) + currentPriceChange;
        
            uint128 totalPriceChange = _auction.endingPrice - _auction.startingPrice;
            uint256 currentPriceChange = totalPriceChange * (secondsPassed / _auction.duration);
            uint256 currentPrice = _auction.startingPrice + currentPriceChange;

            return uint256(currentPrice);
      }
  }
}

