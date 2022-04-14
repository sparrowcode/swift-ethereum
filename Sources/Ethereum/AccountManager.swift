import Foundation

class AccountManager {
    
    private let storage: StorageProtocol
    
    public init(storage: StorageProtocol) {
        self.storage = storage
    }
    
    public func createAccount() throws -> Account {
        
        let randomBytes = Data(0..<32).map { _ in UInt32.random(in: UInt32.min...UInt32.max) }
        
        let privateKeyData = Data(bytes: randomBytes, count: 32)
        
        let privateKey = String(bytes: privateKeyData)
        
        try storage.storePrivateKey(privateKey)
        
        return try Account(privateKey: privateKey)
    }
    
    public func importAccount(privateKey: String) throws -> Account {
        
        try storage.storePrivateKey(privateKey)
        
        return try Account(privateKey: privateKey.removeHexPrefix())
    }
    
    public func removeAccount(_ account: Account) throws {
        try storage.removePrivateKey(for: account.address)
    }
    
}
