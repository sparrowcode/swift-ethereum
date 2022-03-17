# SPEthereum

## Client or Provider
Interacts with [evm client](https://ethereum.org/en/developers/docs/nodes-and-clients) which gives access to interplay with ethereum blockchain (ex: call smart contract functions).
A required property for initialising is a url of rpc server

## Smart Contract
Is a representation of a smart contract (surprisingly).
For a simplified usage, common contratcts should be added as a static constatnts (.eth, .erc721, .erc20 etc). Web3j provides a feature to generate java code from the binary executable of solidity smart contract, this feature shold be considered

## Storage
Is a place where keys of accounts are being held. Has to be secure (use keychain) and requires a password for encryption and decryption

## Account
Manages creation and information of an ethereum account. A good feature wold be to provide login via popular ethereum wallets such as metamask, openwallet, rainbow. Used for signing transactions and requires a storage to be initialised

## Block
A representation of an ethereum [block](https://ethereum.org/en/developers/docs/blocks) that holds several transactions

## Transaction
A representstion of an [ethereum transaction](https://ethereum.org/en/developers/docs/transactions/) that executes on [evm](https://ethereum.org/en/developers/docs/evm/)

## Utils
Incapsulates commonly used code such as conversion from gwei to eth, wei to eth and etc.


