# swift-ethereum

Going to be official Ethereum repo for Swift. There is active progress right now. We will soon get the documentation in order and offer examples of use.

## Account

### Create a new account

#### In order to create a new account you have to use AccountManager. It secures your private key with AES encryption. You can also select a storage, where to hold the encrypted data.
```swift
let storage = UserDefaultsStorage(password: "password")
        
let accountManager = AccountManager(storage: storage)
        
let account = try accountManager.importAccount(privateKey: "your_private_key")
```
#### All the fields of your account are decoded from your private key by the library, so after importing your account you can just tap to them:
```swift
let address = account.address
let publicKey = account.publicKey
let privateKey = account.privateKey
```
### Interacting with Ethereum

#### The abstraction between you and Ethereum is EthereumService. By default it is set to the mainnet, but you can easily change it by setting new Node:
```swift
EthereumService.provider = Provider(node: .ropsten)
```
#### To get balance of any address:
```swift
let balance = try await EthereumService.getBalance(for: "address")
```