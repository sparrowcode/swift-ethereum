# swift-ethereum

Going to be official Ethereum repo for Swift. There is active progress right now. We will soon get the documentation in order and offer examples of use.

## Account

### Create a new account

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

## Interacting with Ethereum

The abstraction between you and Ethereum is EthereumService. By default it is set to the mainnet, but you can easily change it by setting new Node:

```swift
EthereumService.provider = Provider(node: .ropsten)
```

To send a transaction:

```swift
let value = "1000000000000000000" // 1 eth in wei
let transaction = try Transaction(from:"0xE92A146f86fEda6D14Ee1dc1BfB620D3F3d1b873",
                                  gasLimit: "210000",
                                  gasPrice: "250000000000",
                                  to: "0xc8DE4C1B4f6F6659944160DaC46B29a330C432B2",
                                  value: BigUInt(value))

let transactionHash = try await EthereumService.sendRawTransaction(account: account, transaction: transaction)
```

To call a transaction:

```swift
let transaction = try Transaction(to: "0xF65FF945f3a6067D0742fD6890f32A6960dD817d", input: "0x")

let response = try await EthereumService.call(transaction: transaction, block: "latest")
```

Quick note: block is optional for calling this methods and is set to latest by default

To get balance of any address:

```swift
let balance = try await EthereumService.getBalance(for: "address")
```

To get transactions count:

```swift
let count = try await EthereumService.getTransactionCount(for: address)
```

To get current block number:

```swift
let blockNumber = try await EthereumService.blockNumber()
```

To get current gas price:

```swift
let gasPrice = try await EthereumService.gasPrice()
```

To get block transaction count by block hash:

```swift
let blockTransactionCount = try await EthereumService.getBlockTransactionCountByHash(blockHash: "block_hash")
```

To get block transaction count by block number:

```swift
let blockNumber = 2
let blockTransactionCount = try await EthereumService.getBlockTransactionCountByNumber(blockNumber: blockNumber)
```

To get storage at address:

```swift
let address = "0x295a70b2de5e3953354a6a8344e616ed314d7251"
let storageSlot = 3

let storage = try await EthereumService.getStorageAt(address: address, storageSlot: storageSlot, block: "latest")
```

To get code for address:

```swift
let address = "0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39"

let code = try await EthereumService.getCode(address: address, block: "latest")
```

To get block by hash:

```swift 
let block = try await EthereumService.getBlockByHash(hash: "block_hash")
```

To get block by number:

```swift
let blockNumber = 12312
let block = try await EthereumService.getBlockByNumber(blockNumber: blockNumber)
```

To get transaction by hash:

```swift
let transactionHash = "transaction_hash"

let transaction = try await EthereumService.getTransactionByHash(transactionHash: transactionHash)
```

To get uncle by block number and index:

```swift
let blockNumber = 668
let index = 0

let uncleBlock = try await EthereumService.getUncleByBlockNumberAndIndex(blockNumber: blockNumber, index: index)
```

To get uncle by block hash and index:

```swift
let blockHash = "block_hash"
let index = 0

let uncleBlock = try await EthereumService.getUncleByBlockHashAndIndex(blockHash: blockHash, index: index)
```

To get transaction by block number and index:

```swift
let blockNumber = "5417326"
let index = 0

let transaction = try await EthereumService.getTransactionByBlockNumberAndIndex(blockNumber: blockNumber, index: index)
```

To get transaction by block hash and index:

```swift
let blockHash = "block_hash"
let index = 0

let transaction = try await EthereumService.getTransactionByBlockHashAndIndex(blockHash: blockHash, index: index)
```

To get transaction receipt:

```swift
let transactionHash = "transaction_hash"

let receipt = try await EthereumService.getTransactionReceipt(transactionHash: transactionHash)
```

To estimate gas for transaction:

```swift
let transaction = try Transaction(from: "0xE92A146f86fEda6D14Ee1dc1BfB620D3F3d1b873",
                                  to: "0xc8DE4C1B4f6F6659944160DaC46B29a330C432B2",
                                  value: "1000000")

let estimatedGas = try await EthereumService.estimateGas(for: transaction)
```