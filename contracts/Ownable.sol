// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Ownable {
  address public owner;

  event OwnershipTransferred(
    address indexed previousOwner,  
    address indexed newOwner        
  );

  constructor(){
    owner = msg.sender;
  }

  modifier onlyOwner() {    
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address _newOwner) onlyOwner public{//添加修饰，保证只有拥有者才能将NFT所有权转让给别人
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }

}
