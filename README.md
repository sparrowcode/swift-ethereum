# SPEthereum

## Client or Provider
Is a representation of a [node](https://ethereum.org/en/developers/docs/ethereum-stack/#ethereum-nodes/) which gives access to interact with ethereum blockchain (ex: call smart contract functions)
A required property for initialising is a url of rpc server

## Smart Contract
Is a representation of a smart contract (surprisingly)
For a simplified usage, common contratcts should be added as a static constatnts (.eth, .erc721, .erc20 etc)

## Storage
Is a place where keys of an account are being held. Has to be secure (use keychain) and requires a password for encryption and decryption

## Account
Manages creation and information of an ethereum account. Used for signing transactions and requires a storage to be initialised

## Utils
Incapsulates commonly used code such as conversion from gwei to eth, wei to eth and etc.


