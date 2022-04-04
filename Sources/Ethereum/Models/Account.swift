import Foundation
import SwiftKeccak


protocol AccountProtocol {
    func sign<T: Signable>(_ value: T) throws -> Data
    func sign(transaction: Transaction) throws -> Transaction
}

public protocol Signable {
    var rawData: Data? { get }
}

enum SignError: Error {
    case invalidData
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
    
    public func sign<T>(_ value: T) throws -> Data where T : Signable {
        
        guard let rawData = value.rawData else {
            throw SignError.invalidData
        }
        
        let signedData = try AccountManager.sign(data: rawData, with: privateKey)
        
        return signedData
    }
    
    public func sign(transaction: Transaction) throws -> Transaction {
        
        let signedData = try sign(transaction)
        
        var v = Int(signedData[64])

        if v < 37 {
            v += (transaction.chainID ?? -1) * 2 + 35
        }
        
        let r = signedData.subdata(in: 0..<32)
        let s = signedData.subdata(in: 32..<64)
        
        let signedTransaction = Transaction(transaction: transaction, v: v, r: r, s: s)
        
        return signedTransaction
    }
}
