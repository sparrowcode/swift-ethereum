# swift-ethereum

## Navigate

- [Service](#service)
  - [Storage](#storage)
  - [Provider](#provider)
  - [Auth](#auth)
- [Wallet](#wallet)
  - [Account](#account)
- [Transaction](#transaction)
- [Smart contract](#smart-contract)
- [Block](#block)
- [Extension](#extension)


## Service
Base service of the library. Global source of truth.
### Storage
Is a place where keys of accounts are securely stored. Has to be secure (use keychain) and requires a password for encryption and decryption

### Provider
Interacts with [evm client](https://ethereum.org/en/developers/docs/nodes-and-clients) which gives access to interplay with ethereum blockchain (ex: call smart contract functions).
A required property for initialising is a url of rpc server

### Auth
Authenticates accounts, manages creation of an account. A good feature wold be to provide login via popular ethereum wallets such as metamask, openwallet, rainbow.

## Wallet
Place where accounts are being held and managed.

### Account
Information of an ethereum account. Used for signing transactions.

## Extension
Incapsulates commonly used code such as conversion from gwei to eth, wei to eth and etc.

## Smart Contract
Is a representation of a smart contract. For a simplified usage, common contratcts should be added as a static constatnts (.eth, .erc721, .erc20 etc). Web3j provides a feature to generate java code from the binary executable of solidity smart contract, this feature shold be considered

## Block
A representation of an ethereum [block](https://ethereum.org/en/developers/docs/blocks) that holds several transactions

## Transaction
A representstion of an [ethereum transaction](https://ethereum.org/en/developers/docs/transactions/) that executes on [evm](https://ethereum.org/en/developers/docs/evm/)



