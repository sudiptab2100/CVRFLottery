require("@nomiclabs/hardhat-waffle");
require('@nomiclabs/hardhat-ethers');
require("@nomiclabs/hardhat-etherscan");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

require("@nomiclabs/hardhat-ethers");
const fs = require('fs');
const secrets = JSON.parse(fs.readFileSync(`./secrets.json`, 'utf8'))
const privateKey = secrets.privateKey;
const polygonscan = secrets.polygonscan;
module.exports = {
  solidity: "0.8.0",
  networks: {
    matic: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [privateKey]
    }
  },

  etherscan: {
    apiKey: polygonscan,
  }

};