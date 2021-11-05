import App from './buy-nft'
import $ from 'jquery';
// window.jQuery = $;
// window.$ = $;

let web3 = require('web3')
let ViewAuctionM = {
  init: () => {
    console.log('ViewAuctionM init')
    return ViewAuctionM.bindEvents()
  },

  bindEvents: () => {
    $('#viewAuctionModal').on('click', '#buyButton', ViewAuctionM.getCurrentPrice)
  },

  getCurrentPrice: () => {
    web3.eth.getAccounts((error, accounts) => {
      if (error) {
        throw error
      }

      const account = accounts[0]
      const auctionId  = parseInt($('#viewAuctionModal .panel-body').data('auction-id'))
      const tokenToBuy = parseInt($('#viewAuctionModal .number-template .number').data('token-id'))

      /*
      console.log(   'account: ' + account)
      console.log( 'auctionId: ' + auctionId)
      console.log('tokenToBuy: ' + tokenToBuy)
      */

      App.contracts.ETH_Auction.deployed().then((instance) => {
        return instance.getCurrentPriceByAuctionId(auctionId, {from: account})
      }).then((currentPrice) => {
        console.log(`current price: ${currentPrice}`)
        return ViewAuctionM.bid(currentPrice, {from: account})
      }).catch((err) => {
        console.error(err.message)
      })
    })

  },

  bid: (price) => {
    // get values
    const tokenToBuy = $('#viewAuctionModal .number-template .number').attr('data-token-id')

    web3.eth.getAccounts((error, accounts) => {
      if (error) {
        throw error.message
      }

      const account = accounts[0]

      App.contracts.ETH_Auction.deployed().then((instance) => {
        console.log(`calling instance.bid() with price: ${price}`)
        // TODO: calculate fixed gas amount
        return instance.bid(tokenToBuy, {value: price, from: account, gas: 250000})
      }).then((result) => {
        return $('#viewAuctionModal').modal('hide')
      }).catch((err) => {
        console.error(err.message)
      })
    })

  },
}

$(() => {
  $(window).on('load', () => {
    ViewAuctionM.init()
  })
})
