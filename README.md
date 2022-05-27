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

#### To get uncle by block number and index:

```swift
let blockNumber = 668
let index = 0

let uncleBlock = try await EthereumService.getUncleByBlockNumberAndIndex(blockNumber: blockNumber, index: index)
```

#### To get uncle by block hash and index:

```swift
let blockHash = "block_hash"
let index = 0

let uncleBlock = try await EthereumService.getUncleByBlockHashAndIndex(blockHash: blockHash, index: index)
```

#### To get transaction by block number and index:

```swift
let blockNumber = "5417326"
let index = 0

let transaction = try await EthereumService.getTransactionByBlockNumberAndIndex(blockNumber: blockNumber, index: index)
```

#### To get transaction by block hash and index:

```swift
let blockHash = "block_hash"
let index = 0

let transaction = try await EthereumService.getTransactionByBlockHashAndIndex(blockHash: blockHash, index: index)
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


The flow is super easy, we provide factory for both erc20 and erc721 contracts. Factory lets you generate a transaction and then you can call or send it with EthereumService

For example, to get balance of an address for any token:

```swift
let contractAddress = "token_address" 
let address = "address_to_check_balance"

let transaction = try ERC20TransactionFactory.generateBalanceTransaction(address: address, contractAddress: contractAddress)
```

Then just call the transaction with EthereumService, get the abi encoded result and decode it using ABIDecoder:

```swift
let abiEncodedBalance = try await EthereumService.call(transaction: transaction)

let balance = try ABIDecoder.decode(abiEncodedBalance, to: .uint()) as? BigUInt
```

If the abi encoded result contains several types, provide them in an array:

```swift
let decodedResult = try ABIDecoder.decode(someEncodedValue, to: [.uint(), .string, .address])
```

To encode parameters:

```swift
let params = [SmartContractParam(type: .address,  value: ABIEthereumAddress(to)),
              SmartContractParam(type: .uint(), value: value)]
        
let method = SmartContractMethod(name: "method_name", params: params)

guard let data = method.abiData else {
    return
}
```
