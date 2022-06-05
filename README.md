# swift-ethereum

Going to be official Ethereum repo for Swift. There is active progress right now. We will soon get the documentation in order and offer examples of use.

## Installation

### Swift Package Manager
The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Once you have your Swift package set up, adding as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/sparrowcode/swift-ethereum.git", .branchItem("main"))
]
```

## Navigation 
- [Account](#account)
    - [Create new account](#create-new-account)
    - [Import account](#import-account)
    - [Remove account from manager](#remove-account-from-manager)
    - [Sign data](#sign-data)
- [Storage](#storage)
    - [AES](#to-secure-private-keys-in-a-storage-make-use-of-aes)
    - [Encrypting private key](#encrypting-private-key)
    - [Decrypting](#decrypting)
- [Interacting with Ethereum](#interacting-with-ethereum)
    - [Send a transaction](#send-a-transaction)
    - [Call a transaction](#call-a-transaction)
    - [Get balance](#get-balance-of-any-address)
    - [Get transactions count](#get-transactions-count)
    - [Get current block number](#get-current-block-number)
    - [Get current gas price](#get-current-gas-price)
    - [Get block transaction count by block hash](#get-block-transaction-count-by-block-hash)
    - [Get block transaction count by block number](#get-block-transaction-count-by-block-number)
    - [Get storage at address](#get-storage-at-address)
    - [Get code for address](#get-code-for-address)
    - [Get block by hash](#get-block-by-hash)
    - [Get block by number](#get-block-by-number)
    - [Get transaction by hash](#get-transaction-by-hash)
    - [Get uncle by block hash and index](#get-uncle-by-block-hash-and-index)
    - [Get uncle by block number and index](#get-uncle-by-block-number-and-index)
    - [Get transaction by block hash and index](#get-transaction-by-block-hash-and-index)
    - [Get transaction by block number and index](#get-transaction-by-block-number-and-index)
    - [Get transaction receipt](#get-transaction-receipt)
    - [Estimate gas for transaction](#estimate-gas-for-transaction)
- [Node](#getting-info-about-the-node)
    - [Initialize custom node](#initialize-a-node-with-your-custom-rpc-url)
    - [Get version](#get-version)
    - [Check if listening](#check-if-listening)
    - [Get peer count](#get-peer-count)
    - [Get client version](#get-client-version)
- [Utils](#utils)
    - [Get public key from private key](#get-public-key-from-private-key)
    - [Get address from public key](#get-address-from-public-key)
    - [Convert Ethereum Units](#convert-ethereum-units)
- [Smart Contracts](#smart-contracts-and-abi-decodingencoding)
    - [ERC20](#erc20)
        - [Get balance](#get-balance)
        - [Transfer tokens](#transfer-tokens)
        - [Get decimals](#get-decimals)
        - [Get symbol](#get-symbol)
        - [Get total supply](#get-total-supply)
        - [Get name](#get-name)
    - [ERC721](#erc721)
        - [Get balance](#get-balance-1)
        - [Get owner of](#get-owner-of)
        - [Get name](#get-name-1)
        - [Get symbol](#get-symbol)
        - [Get token URI](#get-token-uri)
        - [Get total supply](#get-total-supply-1)
    - [Calling Smart Contract transaction and decoding response](#calling-smart-contract-transaction-and-decoding-response)
    - [Sending Smart Contract transaction](#sending-smart-contract-transaction)
    - [Custom Contracts](#custom-contracts)

## Account

### Create new account
In order to create a new account you have to use AccountManager. It secures your private key with AES encryption. You can also select a storage, where to hold the encrypted data.

```swift
let account = try accountManager.createAccount()
```

### Import account
```swift
let storage = UserDefaultsStorage(password: "password")
        
let accountManager = AccountManager(storage: storage)
        
let account = try accountManager.importAccount(privateKey: "your_private_key")
```

All the fields of your account are decoded from your private key by the library, so after importing your account you can just tap to them:

```swift
let address = account.address
let publicKey = account.publicKey
let privateKey = account.privateKey
```

### Remove account from manager

```swift
try accountManager.removeAccount(account)
```

### Sign data

You can sign any instance of a type that confirms to `RLPEncodable` with your private key:

```swift
let signedData = try account.sign(rlpEncodable)
```

To confirm your type to `RLPEncodable` protocol provide how the data should be encoded for your type in `encodeRLP()` method:

```swift
struct SomeType {
    let name: String
}

extension SomeType: RLPEncodable {
    func encodeRLP() throws -> Data {
        return try RLPEncoder.encode(self.name)
    }
}
```

Read more about RLP here: [RLP Ethereum Wiki](https://eth.wiki/fundamentals/rlp)

## Storage

A custom storage can be created by confirming to `StorageProtocol`:

```swift
struct CustomStorage: StorageProtocol {

    func storePrivateKey(_ privateKey: String) throws {
        // store private key in database of your choice
    }

    func getPrivateKey(for address: String) throws -> String {
        // get private key from storage for address
    }

    func removePrivateKey(for address: String) throws {
        // removes private key from storage
    }
}
```

### To secure private keys in a storage make use of `AES`

#### Encrypting private key:

```swift
let privateKey = "some_private_key"

let aes = AES()

let iv = aes.initialVector // a vector that is used for encrypting the data

let aesEncryptedPrivateKey = try aes.encrypt(privateKey, password: password, iv: iv)
```

The encrypt method accepts only the `hexidecimal string of bytes representation` ex: "0xfce353f6616263" or any `Data`

#### Decrypting:

```swift
let decryptedPrivateKey = try aes.decrypt(aesEncryptedPrivateKey, password: password, iv: iv)
```

## Interacting with Ethereum

The abstraction between you and Ethereum is `EthereumService`. Before starting to call methods you have to configure provider with a [Node](#initialize-a-node-with-your-custom-rpc-url):

```swift
let node = try Node(url: "https://mainnet.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")
EthereumService.configureProvider(with: node)
```

#### Send a transaction:

```swift
let value = "1000000000000000000" // 1 eth in wei
let transaction = try Transaction(from:"0xE92A146f86fEda6D14Ee1dc1BfB620D3F3d1b873",
                                  gasLimit: "210000",
                                  gasPrice: "250000000000",
                                  to: "0xc8DE4C1B4f6F6659944160DaC46B29a330C432B2",
                                  value: BigUInt(value))

let transactionHash = try await EthereumService.sendRawTransaction(account: account, transaction: transaction)
```

#### Call a transaction:

```swift
let transaction = try Transaction(to: "0xF65FF945f3a6067D0742fD6890f32A6960dD817d", input: "0x")

let response = try await EthereumService.call(transaction: transaction, block: "latest")
```

> Quick note: block is optional for calling this methods and is set to latest by default

#### Get balance of any address:

```swift
let balance = try await EthereumService.getBalance(for: "address")
```

#### Get transactions count:

```swift
let count = try await EthereumService.getTransactionCount(for: "address")
```

#### Get current block number:

```swift
let blockNumber = try await EthereumService.blockNumber()
```

#### Get current gas price:

```swift
let gasPrice = try await EthereumService.gasPrice()
```

#### Get block transaction count by block hash:

```swift
let blockTransactionCount = try await EthereumService.getBlockTransactionCountByHash(blockHash: "block_hash")
```

#### Get block transaction count by block number:

```swift
let blockNumber = 2
let blockTransactionCount = try await EthereumService.getBlockTransactionCountByNumber(blockNumber: blockNumber)
```

#### Get storage at address:

```swift
let address = "0x295a70b2de5e3953354a6a8344e616ed314d7251"
let storageSlot = 3

let storage = try await EthereumService.getStorageAt(address: address, storageSlot: storageSlot, block: "latest")
```

#### Get code for address:

```swift
let address = "0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39"

let code = try await EthereumService.getCode(address: address, block: "latest")
```

#### Get block by hash:

```swift 
let block = try await EthereumService.getBlockByHash(hash: "block_hash")
```

#### Get block by number:

```swift
let blockNumber = 12312

let block = try await EthereumService.getBlockByNumber(blockNumber: blockNumber)
```

#### Get transaction by hash:

```swift
let transactionHash = "transaction_hash"

let transaction = try await EthereumService.getTransactionByHash(transactionHash: transactionHash)
```

#### Get uncle by block hash and index:

```swift
let blockHash = "block_hash"
let index = 0

let uncleBlock = try await EthereumService.getUncleByBlockHashAndIndex(blockHash: blockHash, index: index)
```

#### Get uncle by block number and index:

```swift
let blockNumber = 668
let index = 0

let uncleBlock = try await EthereumService.getUncleByBlockNumberAndIndex(blockNumber: blockNumber, index: index)
```

#### Get transaction by block hash and index:

```swift
let blockHash = "block_hash"
let index = 0

let transaction = try await EthereumService.getTransactionByBlockHashAndIndex(blockHash: blockHash, index: index)
```

#### Get transaction by block number and index:

```swift
let blockNumber = 5417326
let index = 0

let transaction = try await EthereumService.getTransactionByBlockNumberAndIndex(blockNumber: blockNumber, index: index)
```

#### Get transaction receipt:

```swift
let transactionHash = "transaction_hash"

let receipt = try await EthereumService.getTransactionReceipt(transactionHash: transactionHash)
```

#### Estimate gas for transaction:

```swift
let transaction = try Transaction(from: "0xE92A146f86fEda6D14Ee1dc1BfB620D3F3d1b873",
                                  to: "0xc8DE4C1B4f6F6659944160DaC46B29a330C432B2",
                                  value: "100000000000")

let estimatedGas = try await EthereumService.estimateGas(for: transaction)
```

## Getting info about the Node

#### Initialize a node with your custom rpc url
```swift
let node = try Node(url: "your_custom_rpc_url")
```

#### Get version:

```swift
let version = try await node.version()
```

#### Check if listening:

```swift
let isListening = try await node.listening()
```

#### Get peer count:

```swift
let peerCount = try await node.peerCount()
```

#### Get client version:

```swift
let clientVersion = try await node.clientVersion()
```


## Utils

We provide commonly used scenarious under an easy interface

#### Get public key from private key:

```swift
let privateKey = "private_key"

let publicKey = try Utils.KeyUtils.getPublicKey(from: privateKey)
```

#### Get address from public key:

```swift
let publicKey = "public_key"

let ethereumAddress = try Utils.KeyUtils.getEthereumAddress(from: publicKey)
```

#### Convert Ethereum Units:

```swift
let wei = "12345678901234567890"
let eth = Utils.Converter.convert(value: wei, from: .wei, to: .eth)
```

## Smart Contracts and ABI Decoding/Encoding

We decided to create a transaction based flow for interacting with smart contracts, because of scalable architecture and lack of strong relations

The flow is super easy, we provide factory for both ERC20 and ERC721 contracts. Factory lets you generate transactions and then you can [call or send them via EthereumService](#calling-smart-contract-transaction-and-decoding-response)

### ERC20

```swift
let contractAddress = "erc20_contract_address" 
```

#### Get balance:

```swift
let address = "address_to_check_balance"

let transaction = try ERC20TransactionFactory.generateBalanceTransaction(address: address, contractAddress: contractAddress)
```

#### Transfer tokens:

```swift
let value = BigUInt(some_value)
let toAddress = "to_address"
let gasLimit = BigUInt(gas_limit_value)
let gasPrice = BigUInt(gas_price_value)

let transaction = try ERC20TransactionFactory.generateTransferTransaction(value: value, 
                                                                          to: toAddress,
                                                                          gasLimit: gasLimit,
                                                                          gasPrice: gasPrice, 
                                                                          contractAddress: contractAddress)
```

#### Get decimals:

```swift
let transaction = try ERC20TransactionFactory.generateDecimalsTransaction(contractAddress: contractAddress)
```

#### Get symbol:

```swift
let transaction = try ERC20TransactionFactory.generateSymbolTransaction(contractAddress: contractAddress)
```

#### Get total supply:

```swift
let transaction = try ERC20TransactionFactory.generateTotalSupplyTransaction(contractAddress: contractAddress)
```

#### Get name:

```swift
let transaction = try ERC20TransactionFactory.generateNameTransaction(contractAddress: contractAddress)
```

### ERC721

```swift
let contractAddress = "erc721_contract_address"
```

#### Get balance:

```swift
let transaction = try ERC721TransactionFactory.generateBalanceTransaction(address: address, contractAddress: contractAddress)
```

#### Get owner of:

```swift
let tokenId = BigUInt(708)
        
let transaction = try ERC721TransactionFactory.generateOwnerOfTransaction(tokenId: tokenId, contractAddress: contractAddress)
```

#### Get name:

```swift
let transaction = try ERC721TransactionFactory.generateNameTransaction(contractAddress: contractAddress)
```

#### Get symbol:

```swift
let transaction = try ERC721TransactionFactory.generateSymbolTransaction(contractAddress: contractAddress)
```

#### Get token URI:

```swift
let tokenId = BigUInt(708)

let transaction = try ERC721TransactionFactory.generateTokenURITransaction(tokenId: tokenId, contractAddress: contractAddress)
```

#### Get total supply:

```swift
let transaction = try ERC721TransactionFactory.generateTotalSupplyTransaction(contractAddress: contractAddress)
```

#### Calling Smart Contract transaction and decoding response:

Then just call the transaction with EthereumService, get the abi encoded result and decode it using ABIDecoder:

```swift
// transaction is a erc20 balance one
let abiEncodedBalance = try await EthereumService.call(transaction: transaction)

let balance = try ABIDecoder.decode(abiEncodedBalance, to: .uint()) as? BigUInt
```

If the abi encoded result contains several types, provide them as an array:

```swift
let decodedResult = try ABIDecoder.decode(someEncodedValue, to: [.uint(), .string, .address])
```

> Decode method accepts both Data and String values

#### Sending Smart Contract transaction:

If the transaction is a transfer one, send it via EthereumService:

```swift
let transactionHash = try await EthereumService.sendRawTransaction(account: account, transaction: transaction)
```

### Custom Contracts

If you have a custom contract that you want to interact with, the flow is again very intuitive:

1. Select a method that you want to call from your contract:

For example we want to call this method:

```
function balanceOf(address _owner) constant returns (uint balance);
```

2. Check the input and output parameters of the method:

Method accepts on address type as an input and returns a uint

3. Encode parameters:

```swift
let params = [SmartContractParam(type: .address,  value: ABIEthereumAddress("some_address"))]
        
let method = SmartContractMethod(name: "balanceOf", params: params)

guard let data = method.abiData else {
    return
}
```

4. Create a transaction:

```swift
let  contractAddress = "contract_address"

let transaction = try Transaction(input: data, to: contractAddress)
```

That's all, next you can [call the transaction and decode the response](#calling-smart-contract-transaction-and-decoding-response)
