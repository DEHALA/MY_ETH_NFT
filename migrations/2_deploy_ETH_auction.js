/* eslint-disable no-undef */
const ETH_auction = artifacts.require("ETH_auction");
const NumbersNFT = artifacts.require('NumbersNFT.sol');

module.exports = function (deployer) {
  // address = '0xC34Dc06bcC4dD355Acc96E21762F6520626055B7';
  // deployer.deploy(ETH_auction,address);

  deployer.deploy(NumbersNFT, 'NumbersNFT', 'NNFT').then(function() {
    return deployer.deploy(ETH_auction, NumbersNFT.address);
  });
};
