require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    fuji: {
      url: "https://ava-testnet.public.blastapi.io/ext/bc/C/rpc",
      chainId: 43113,
      accounts: ["9598f1a1ac52c5ddded69bc0a3e27bf700ee4800576a06f27c7913b6f6854850"]
    }
  }
};
