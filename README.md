# swift-ethereum

## Navigate

- [Service](#service)
  - [Storage](#storage)
  - [Provider](#provider)
  - [Wallet](#wallet)
    - [Account](#account)
- [Transaction](#transaction)
- [Smart contract](#smart-contract)
- [Block](#block)
- [Extension](#extension)


## Service
Base service of the library. Incapsulates ethereum blockchain methods inside itself. Uses [provider](#provider) which gives access to interplay with ethereum blockchain (ex: call smart contract functions). Global source of truth

### Storage
Is a place where keys of accounts are stored. Has to be secure (uses keychain) and requires a password for encryption and decryption

### Provider
The representation of an [evm client](https://ethereum.org/en/developers/docs/nodes-and-clients). A required property for initialising is a url of rpc server. For a simplified usage, mainnet and testnets shold be added (from Infuria for example)

### Wallet
Place where accounts are being held and managed.
Authenticates accounts, manages creation of an account. A good feature would be to provide login via popular ethereum wallets such as metamask, openwallet, rainbow

#### Account
Information of an ethereum account. Used for signing transactions

## Smart Contract
Is a representation of a smart contract. For a simplified usage, common contratcts should be added (.erc721, .erc20 .erc1155 etc). Web3j provides a feature to generate java code from the binary executable of solidity smart contract, this feature shold be considered

## Block
A representation of an ethereum [block](https://ethereum.org/en/developers/docs/blocks) that holds several transactions

## Transaction
A representation of an [ethereum transaction](https://ethereum.org/en/developers/docs/transactions/) that executes on [evm](https://ethereum.org/en/developers/docs/evm/)

## Extension
Incapsulates commonly used code such as conversion from gwei to eth, wei to eth, encryption and decryption using alhrotithms and etc.


