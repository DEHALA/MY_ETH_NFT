// https://medium.com/metamask/https-medium-com-metamask-breaking-change-injecting-web3-7722797916a8

// let Web3 = require('web3')
// let web3 = new Web3()
// if (window.ethereum) {
//     web3 = new Web3(window.ethereum)
// } else if (window.web3) {
//     web3 = new Web3(web3.currentProvider)
// } else {
//     alert('你需要先安装MetaMask')
// }
// web3.eth.defaultAccount = web3.eth.accounts[0];
// window.ethereum.enable()
// module.exports = web3

import $ from 'jquery';
// window.jQuery = $;
// window.$ = $;

let Web3 = require('web3')
let web3 = new Web3()
window.addEventListener('load', async () => {
  // Modern dapp browsers...
if (window.ethereum) {
  web3 = new Web3(window.ethereum)
  
  try {
    // Request account access if needed
    $('#overlay').show()
    $('#overlay .web3-not-unlocked').show()
    await window.ethereum.enable()
    // Acccounts now exposed
    $('#overlay').hide()

    // Listen for account changes
    let account = web3.eth.accounts[0]
    setInterval(() => {
      if (web3.eth.accounts[0] !== account) {
        account = web3.eth.accounts[0]
        // update interface
        window.location.reload()
      }
    }, 1000)

  } catch (error) {
    // User denied account access...
    console.log('user denied account access')
  }
}
// Legacy dapp browsers...
else if (window.web3) {
  web3 = new Web3(web3.currentProvider)
  // Acccounts always exposed
}
// Non-dapp browsers...
else {
  $('#overlay').show()
  $('#overlay .no-web3-browser').show()
  console.log('Non-Ethereum browser detected. You should consider trying MetaMask!')
}
})
// window.ethereum.enable()
// // module.exports = web3;
// // exports.module = web3;
// export default web3
