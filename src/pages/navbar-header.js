import ReactDOM from 'react-dom';
import React from 'react';
import web3 from './init-web3';
import $ from 'jquery';
// window.jQuery = $;
// window.$ = $;

window.addEventListener('load', () => {
  web3.eth.getAccounts((error, accounts) => {
    if (!error) {
      const account = accounts[0]
      // shorten
      const shortenedAccount = account.substring(0,8) + '...'
      $('#connectedAccount').append(`<a>Account: ${shortenedAccount}</a>`)
    } else {
      console.error(error)
    }
  })
})


// function navbarHeader = <div>
// <div class="container-fluid">

//   <div id="overlay">
//     <div class="content">
//       <div class="no-web3-browser">
//         <h1>You need to use a web3 compatible browser in order to use this app.</h1>
//         <h3>Have a look at one of the following options:</h3>
//         <h4>
//           <a href="https://metamask.io/" target="_blank">-> MetaMask Extension</a>
//         </h4>
//         <h4>
//           <a href="https://brave.com/" target="_blank">-> Brave Browser</a>
//         </h4>
//       </div>
//       <div class="web3-not-unlocked">
//         <h1>Please unlock this app to view your accounts.</h1>
//       </div>
//     </div>
//   </div>

//   <!-- Brand and toggle get grouped for better mobile display -->
//   <div class="navbar-header">
//     <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
//       <span class="sr-only">Toggle navigation</span>
//       <span class="icon-bar"></span>
//       <span class="icon-bar"></span>
//       <span class="icon-bar"></span>
//     </button>
//     <a class="navbar-brand" href="./index.html">N(umber)FT</a>
//   </div>

//   <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
//     <ul class="nav navbar-nav">
//       <li>
//         <a href="./auctions.html">Auctions</a>
//       </li>
//       <li>
//         <a href="./inventory.html">Inventory</a>
//       </li>
//     </ul>
//     <ul class="nav navbar-nav pull-right">
//       <li id="connectedAccount" class="pull-right">
//       </li>
//     </ul>
//   </div>
// </div>
// </div>
// ReactDOM.render(navbarHeader, document.getElementById('app > .navbar'))
