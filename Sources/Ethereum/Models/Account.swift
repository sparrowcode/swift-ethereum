import Foundation
import SwiftKeccak

public struct Account {
    
    public let address: String
    public let publicKey: String
    public let privateKey: String
    
    init(privateKey: String) throws {
        
        self.privateKey = privateKey
        self.publicKey = try Utils.KeyUtils.getPublicKey(from: privateKey.removeHexPrefix())
        self.address = try Utils.KeyUtils.getEthereumAddress(from: publicKey)
    }
    
    public func sign<T>(_ value: T) throws -> Signature where T : RLPEncodable {
        
        let rlpData = try value.encodeRLP()
        
        let signedData = try Utils.KeyUtils.sign(data: rlpData, with: privateKey.removeHexPrefix())
        
        return signedData
    }
    
    public func sign(transaction: Transaction) throws -> Transaction {
        
        var signature = try sign(transaction)
        
        signature.calculateV(with: transaction.chainID)
        
        let signedTransaction = try Transaction(transaction: transaction, signature: signature)
        
        return signedTransaction
    }
}

extension Account: Equatable {}
