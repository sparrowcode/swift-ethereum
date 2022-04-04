import Foundation
import secp256k1
import SwiftKeccak

class AccountManager {
    
    private let storage: StorageProtocol
    
    public init(storage: StorageProtocol) {
        self.storage = storage
    }
    
    public static func createAccount() throws -> Account {
        // MARK: - store private key in storage
        let randomBytes = Data(0..<32).map({ _ in UInt32.random(in: UInt32.min...UInt32.max) })
        
        let privateKeyData = Data(bytes: randomBytes, count: 32)
        
        let privateKey = String(bytes: privateKeyData)
        
        return try Account(privateKey: privateKey)
    }
    
    public static func importAccount(privateKey: String) throws -> Account {
        // MARK: - store private key in storage
        return try Account(privateKey: privateKey)
    }
    
    public static func removeAccount(_ account: Account) {
        
    }
    
    public static func sign(data: Data, with privateKey: String) throws -> Data {
        
        let privateKeyBytes = try privateKey.lowercased().bytes
        
        let secp256k1PrivateKey = try secp256k1.Signing.PrivateKey(rawRepresentation: privateKeyBytes, format: .uncompressed)
        
        // MARK: - Make use of simplified syntex
        
        //        let keccakData = data.keccak()
        //
        //        let digets = SHA256.convert(keccakData.bytes)
        //
        //        let signature = try secp256k1PrivateKey.ecdsa.signature(for: digets)
        //
        //        let compactRepresentation = try signature.rawRepresentation
        
        guard let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY)) else {
            print("Failed to sign message: invalid context.")
            throw JSONRPCError.errorSigningTransaction
        }
        
        defer {
            secp256k1_context_destroy(ctx)
        }
        
        let msgData = data.keccak()
        
        let msg = (msgData as NSData).bytes.assumingMemoryBound(to: UInt8.self)
        
        let privateKeyPtr = (secp256k1PrivateKey.rawRepresentation as NSData).bytes.assumingMemoryBound(to: UInt8.self)
        
        let signaturePtr = UnsafeMutablePointer<secp256k1_ecdsa_recoverable_signature>.allocate(capacity: 1)
        
        defer {
            signaturePtr.deallocate()
        }
        
        guard secp256k1_ecdsa_sign_recoverable(ctx, signaturePtr, msg, privateKeyPtr, nil, nil) == 1 else {
            print("Failed to sign message: recoverable ECDSA signature creation failed.")
            throw JSONRPCError.errorSigningTransaction
        }
        
        let outputPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
        
        defer {
            outputPtr.deallocate()
        }
        
        var recid: Int32 = 0
        secp256k1_ecdsa_recoverable_signature_serialize_compact(ctx, outputPtr, &recid, signaturePtr)
        
        let outputWithRecidPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: 65)
        
        defer {
            outputWithRecidPtr.deallocate()
        }
        
        outputWithRecidPtr.assign(from: outputPtr, count: 64)
        outputWithRecidPtr.advanced(by: 64).pointee = UInt8(recid)
        
        let signature = Data(bytes: outputWithRecidPtr, count: 65)
        
        return signature
    }
    
    public static func getPublicKey(from privateKey: String) throws -> String {
        
        let privateKeyBytes = try privateKey.lowercased().bytes
        
        let secp256k1PrivateKey = try secp256k1.Signing.PrivateKey(rawRepresentation: privateKeyBytes, format: .uncompressed)
        
        let publicKey = secp256k1PrivateKey.publicKey.rawRepresentation.subdata(in: 1..<65)
        
        return String(bytes: publicKey)
    }
    
    public static func getEthereumAddress(from publicKey: String) throws -> String {
        
        let publicKeyBytes = try publicKey.lowercased().bytes
        
        let publicKeyData = Data(bytes: publicKeyBytes, count: 64)
        
        let hash = keccak256(publicKeyData)
        
        let address = hash.subdata(in: 12..<hash.count)
        
        let ethereumAddress = "0x" + String(bytes: address)
        
        return ethereumAddress
    }
}
