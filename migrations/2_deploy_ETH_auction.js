/* eslint-disable no-undef */
var ETH_auction = artifacts.require("ETH_auction");

module.exports = function (deployer) {
  address = '0xC34Dc06bcC4dD355Acc96E21762F6520626055B7';
  deployer.deploy(ETH_auction,address);
};
