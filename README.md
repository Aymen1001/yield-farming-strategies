# yield-farming-strategies
This is a set of smart contracts used to implement yield farming strategies on different protocols: AAVE, Compound, Uniswap

## Built With:

* [Solidity](https://docs.soliditylang.org/)
* [Brownie](https://eth-brownie.readthedocs.io)
* [OpenZeppelin](https://docs.openzeppelin.com)

## Usage:

### Installation & Setup:

1. Installing Brownie: Brownie is a python framework for smart contracts development,testing and deployments. It's quit like [HardHat](https://hardhat.org) but it uses python for writing test and deployements scripts instead of javascript.
   Here is a simple way to install brownie.
   ```
    pip install --user pipx
    pipx ensurepath
    # restart your terminal
    pipx install eth-brownie
   ```
   Or if you can't get pipx to work, via pip (it's recommended to use pipx)
    ```
    pip install eth-brownie
    ```
   Install [ganache-cli](https://www.npmjs.com/package/ganache-cli): 
   ```sh
    npm install -g ganache-cli
    ```
    
3. Clone the repo:
   ```sh
   git clone https://github.com/Aymen1001/yield-farming-strategies.git
   cd yield-farming-strategies
   ```

4. Set your environment variables:

   To be able to deploy to real testnets you need to add your PRIVATE_KEY (You can find your PRIVATE_KEY from your ethereum wallet like metamask) and the infura project Id (just create an infura account it's free) to the .env file:
   ```
   PRIVATE_KEY=<PRIVATE_KEY>
   WEB3_INFURA_PROJECT_ID=<< YOUR INFURA PROJECT ID >>
   ```
### How to run:

You'll find all the strategies in the scripts folder, in order to test any strategy on the mainnet fork (for testing purposes only, you can also use the kovan testnet) you just need to run the command :
   ```sh
   brownie run scripts/<<strategy-name>>.py --network=mainnet-fork
   ```

