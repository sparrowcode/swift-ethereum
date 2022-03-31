import Foundation
import secp256k1
import SwiftKeccak

class AccountManager {
    
    private let storage: StorageProtocol
    
    public init(storage: StorageProtocol) {
        self.storage = storage
    }
    
    static func createAccount() throws -> Account {
        // MARK: - store private key in storage
        let randomBytes = Data(0..<32).map({ _ in UInt64.random(in: UInt64.min...UInt64.max) })
        
        let privateKeyData = Data(bytes: randomBytes, count: 32)
        
        let privateKey = String(bytes: privateKeyData)
        
        return try Account(privateKey: privateKey)
    }
    
    static func importAccount(privateKey: String) throws -> Account {
        // MARK: - store private key in storage
        return try Account(privateKey: privateKey)
    }
    
    static func removeAccount(_ account: Account) {
        
    }
    
    static func getPublicKey(from privateKey: String) throws -> String {
        
        let privateKeyBytes = try privateKey.lowercased().bytes
        
        let secp256k1PrivateKey = try secp256k1.Signing.PrivateKey(rawRepresentation: privateKeyBytes, format: .uncompressed)
        
        let publicKey = secp256k1PrivateKey.publicKey.rawRepresentation.subdata(in: 1..<65)
        
        return String(bytes: publicKey)
    }
    
    static func getEthereumAddress(from publicKey: String) throws -> String {
        
        let publicKeyBytes = try publicKey.lowercased().bytes
        
        let publicKeyData = Data(bytes: publicKeyBytes, count: 64)
        
        let hash = keccak256(publicKeyData)
        
        let address = hash.subdata(in: 12..<hash.count)
        
        let ethereumAddress = "0x" + address.map { String(format: "%02hhx", $0) }.joined()
        
        return ethereumAddress
    }
}

