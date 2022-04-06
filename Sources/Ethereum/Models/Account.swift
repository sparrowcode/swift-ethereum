import Foundation
import SwiftKeccak

protocol AccountProtocol {
    func sign<T: Signable>(_ value: T) throws -> Signature
    func sign(transaction: Transaction) throws -> Transaction
}

public struct Account: AccountProtocol {
    
    public var address: String
    public var publicKey: String
    public var privateKey: String
    
    init(privateKey: String) throws {
        self.privateKey = privateKey
        self.publicKey = try AccountManager.getPublicKey(from: privateKey)
        self.address = try AccountManager.getEthereumAddress(from: publicKey)
    }
    
    public func sign<T>(_ value: T) throws -> Signature where T : Signable {
        
        guard let rawData = value.rawData else {
            throw SignError.invalidData
        }
        
        let signedData = try AccountManager.sign(data: rawData, with: privateKey)
        
        return signedData
    }
    
    public func sign(transaction: Transaction) throws -> Transaction {
        
        var signature = try sign(transaction)
        
        signature.calculateV(with: transaction.chainID)
        
        let signedTransaction = Transaction(transaction: transaction,
                                            v: signature.v,
                                            r: signature.r,
                                            s: signature.s)
        
        return signedTransaction
    }
}
