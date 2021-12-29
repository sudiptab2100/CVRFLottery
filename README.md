# CVRFLottery
Decentralised lottery system. Chainlink VRF used for randomness in result.

### Setup
```
git clone https://github.com/sudiptab2100/CVRFLottery.git
cd CVRFLottery
npm install
```

### Compile
```
npx hardhat compile
```

### Test
```
npx hardhat test
```

### Deploy on Testnets
npx hardhat run scripts/deploy.js --network <network-name><br />
eg:
```
npx hardhat run scripts/deploy.js --network matic
```

### Verify smart contract on Polygonscan
```
npx hardhat verify --network matic <contract-address>
```