require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-ganache");
/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "rinkeby",
  networks: {
    hardhat: {},
    rinkeby: {
      url: "https://rinkeby.infura.io/v3/7cd4731a3be74a6ab7c32fe799ab3177",
      accounts: [
        "private key",
      ],
      chainId: 4,
      live: true,
      saveDeployments: true,
      // tags: ["staging"],
      // gasPrice: 5000000000,
      // gasMultiplier: 2,
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/7cd4731a3be74a6ab7c32fe799ab3177`,
      accounts: [
        "private key",
      ],
      // gasPrice: 120 * 1000000000,
      // chainId: 1,
    },

    bsctestnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      accounts: [
        "private key",
      ],
      chainId: 97,
      live: true,
      saveDeployments: true,
      // tags: ["staging"],
      // gasPrice: 5000000000,
      // gasMultiplier: 2,
    },
    bscmainnet: {
      url: "https://bsc-dataseed.binance.org/",
      accounts: [
        "private key",
      ],
      chainId: 56,
      live: true,
      saveDeployments: true,
      // tags: ["staging"],
      // gasPrice: 5000000000,
      // gasMultiplier: 2,
    },
  },
  solidity: {
    version: "0.8.6",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  paths: {
    sources: "./contracts",
    // tests: "./test",s
    cache: "./cache",
    artifacts: "./artifacts",
  },
  etherscan: {
    //apiKey: "6F2QV99DME1GBEHFT668GJ64M948SMT75N",
    apiKey: "JTW8VU48ABE6AGUH9E297BJCJUFU6PYTSP"
  },
  mocha: {
    timeout: 20000,
  },
};
