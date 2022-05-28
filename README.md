# swift-ethereum

Going to be official Ethereum repo for Swift. There is active progress right now. We will soon get the documentation in order and offer examples of use.

## Navigation 
- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
- [Account](#account)
    - [Create new account](#create-new-account)
    - [Sign data](#sign-data)
- [Interacting with Ethereum](#interacting-with-ethereum)
    - [Send a transaction](#to-send-a-transaction)
    - [Call a transaction](#to-call-a-transaction)
    - [Get balance](#to-get-balance-of-any-address)
    - [Get transactions count](#to-get-transactions-count)
    - [Get current block number](#to-get-current-block-number)
    - [Get current gas price](#to-get-current-gas-price)
    - [Get block transaction count by block hash](#to-get-block-transaction-count-by-block-hash)
    - [Get block transaction count by block number](#to-get-block-transaction-count-by-block-number)
    - [Get storage at address](#to-get-storage-at-address)
    - [Get code for address](#to-get-code-for-address)
    - [Get block by hash](#to-get-block-by-hash)
    - [Get block by number](#to-get-block-by-number)
    - [Get transaction by hash](#to-get-transaction-by-hash)
    - [Get uncle by block hash and index](#to-get-uncle-by-block-hash-and-index)
    - [Get uncle by block number and index](#to-get-uncle-by-block-number-and-index)
    - [Get transaction by block hash and index](#to-get-transaction-by-block-hash-and-index)
    - [Get transaction by block number and index](#to-get-transaction-by-block-number-and-index)
    - [Get transaction receipt](#to-get-transaction-receipt)
    - [Estimate gas for transaction](#to-estimate-gas-for-transaction)
- [Node](#getting-info-about-the-node)
    - [Initialize custom node](#to-initialize-a-node-with-your-custom-rpc-url)
    - [Get version](#to-get-version)
    - [Check if listening](#to-check-if-listening)
    - [Get peer count](#to-get-peer-count)
    - [Get client version](#to-get-client-version)
- [Utils](#utils)
    - [Get public key from private key](#to-get-public-key-from-private-key)
    - [Get address from public key](#to-get-address-from-public-key)
    - [Get eth from wei](#to-get-eth-from-wei)
- [Smart Contracts](#smart-contracts-and-abi-decodingencoding)
    - [Get balance example](#to-get-balance-of-an-address-for-any-erc20-token)
    - [Calling ERC20 transaction and decoding response](#calling-erc20-transaction-and-decoding-response)
    - [Encode parameters](#to-encode-parameters)

## Installation

### Swift Package Manager
The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Once you have your Swift package set up, adding as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/sparrowcode/swift-ethereum.git", .branchItem("main"))
]
```

## Account

### Create new account

In order to create a new account you have to use AccountManager. It secures your private key with AES encryption. You can also select a storage, where to hold the encrypted data.

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

## Interacting with Ethereum

The abstraction between you and Ethereum is EthereumService. By default it is set to the mainnet, but you can easily change it by setting new `Provider` with `Node` of your choice:

```swift
EthereumService.provider = Provider(node: .ropsten)
```

You can also provide your own rpc url to Node:

```swift
let url = "http_rpc_url"

let node = try Node(url: url)
```

#### To send a transaction:

```swift
let value = "1000000000000000000" // 1 eth in wei
let transaction = try Transaction(from:"0xE92A146f86fEda6D14Ee1dc1BfB620D3F3d1b873",
                                  gasLimit: "210000",
                                  gasPrice: "250000000000",
                                  to: "0xc8DE4C1B4f6F6659944160DaC46B29a330C432B2",
                                  value: BigUInt(value))

let transactionHash = try await EthereumService.sendRawTransaction(account: account, transaction: transaction)
```

#### To call a transaction:

```swift
let transaction = try Transaction(to: "0xF65FF945f3a6067D0742fD6890f32A6960dD817d", input: "0x")

let response = try await EthereumService.call(transaction: transaction, block: "latest")
```

Quick note: block is optional for calling this methods and is set to latest by default

#### To get balance of any address:

```swift
let balance = try await EthereumService.getBalance(for: "address")
```

#### To get transactions count:

```swift
let count = try await EthereumService.getTransactionCount(for: "address")
```

#### To get current block number:

```swift
let blockNumber = try await EthereumService.blockNumber()
```

#### To get current gas price:

```swift
let gasPrice = try await EthereumService.gasPrice()
```

#### To get block transaction count by block hash:

```swift
let blockTransactionCount = try await EthereumService.getBlockTransactionCountByHash(blockHash: "block_hash")
```

#### To get block transaction count by block number:

```swift
let blockNumber = 2
let blockTransactionCount = try await EthereumService.getBlockTransactionCountByNumber(blockNumber: blockNumber)
```

#### To get storage at address:

```swift
let address = "0x295a70b2de5e3953354a6a8344e616ed314d7251"
let storageSlot = 3

let storage = try await EthereumService.getStorageAt(address: address, storageSlot: storageSlot, block: "latest")
```

#### To get code for address:

```swift
let address = "0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39"

let code = try await EthereumService.getCode(address: address, block: "latest")
```

#### To get block by hash:

```swift 
let block = try await EthereumService.getBlockByHash(hash: "block_hash")
```

#### To get block by number:

```swift
let blockNumber = 12312

let block = try await EthereumService.getBlockByNumber(blockNumber: blockNumber)
```

#### To get transaction by hash:

```swift
let transactionHash = "transaction_hash"

let transaction = try await EthereumService.getTransactionByHash(transactionHash: transactionHash)
```

#### To get uncle by block hash and index:

```swift
let blockHash = "block_hash"
let index = 0

let uncleBlock = try await EthereumService.getUncleByBlockHashAndIndex(blockHash: blockHash, index: index)
```

#### To get uncle by block number and index:

```swift
let blockNumber = 668
let index = 0

let uncleBlock = try await EthereumService.getUncleByBlockNumberAndIndex(blockNumber: blockNumber, index: index)
```

#### To get transaction by block hash and index:

```swift
let blockHash = "block_hash"
let index = 0

let transaction = try await EthereumService.getTransactionByBlockHashAndIndex(blockHash: blockHash, index: index)
```

#### To get transaction by block number and index:

```swift
let blockNumber = "5417326"
let index = 0

let transaction = try await EthereumService.getTransactionByBlockNumberAndIndex(blockNumber: blockNumber, index: index)
```

#### To get transaction receipt:

```swift
let transactionHash = "transaction_hash"

let receipt = try await EthereumService.getTransactionReceipt(transactionHash: transactionHash)
```

#### To estimate gas for transaction:

```swift
let transaction = try Transaction(from: "0xE92A146f86fEda6D14Ee1dc1BfB620D3F3d1b873",
                                  to: "0xc8DE4C1B4f6F6659944160DaC46B29a330C432B2",
                                  value: "1000000")

let estimatedGas = try await EthereumService.estimateGas(for: transaction)
```

## Getting info about the Node

#### To initialize a node with your custom rpc url
```swift
let node = try Node(url: "your_custom_rpc_url")
```

#### To get version:

```swift
let version = try await node.version()
```

#### To check if listening:

```swift
let isListening = try await node.listening()
```

#### To get peer count:

```swift
let peerCount = try await node.peerCount()
```

#### To get client version:

```swift
let clientVersion = try await node.clientVersion()
```


## Utils

We provide commonly used scenarious under an easy interface

#### To get public key from private key:

```swift
let privateKey = "private_key"

let publicKey = try Utils.getPublicKey(from: privateKey)
```

#### To get address from public key:

```swift
let publicKey = "public_key"

let ethereumAddress = try Utils.getEthereumAddress(from: publicKey)
```

#### To get eth from wei:

```swift
let wei = "12345678901234567890"
let eth = Utils.ethFromWei(wei)
```

## Smart Contracts and ABI Decoding/Encoding

We decided to create a transaction based flow for interacting with smart contracts, because of scalable architecture and lack of strong relations

The flow is super easy, we provide factory for both ERC20 and ERC721 contracts. Factory lets you generate transactions and then you can call or send them with EthereumService

#### To get balance of an address for any ERC20 token:

```swift
let contractAddress = "token_address" 
let address = "address_to_check_balance"

let transaction = try ERC20TransactionFactory.generateBalanceTransaction(address: address, contractAddress: contractAddress)
```

#### Calling ERC20 transaction and decoding response:

Then just call the transaction with EthereumService, get the abi encoded result and decode it using ABIDecoder:

```swift
let abiEncodedBalance = try await EthereumService.call(transaction: transaction)

let balance = try ABIDecoder.decode(abiEncodedBalance, to: .uint()) as? BigUInt
```

If the abi encoded result contains several types, provide them as an array:

```swift
let decodedResult = try ABIDecoder.decode(someEncodedValue, to: [.uint(), .string, .address])
```

Decode method accepts both Data and String values

#### To encode parameters:

```swift
let params = [SmartContractParam(type: .address,  value: ABIEthereumAddress(to)),
              SmartContractParam(type: .uint(), value: value)]
        
let method = SmartContractMethod(name: "method_name", params: params)

guard let data = method.abiData else {
    return
}
```
