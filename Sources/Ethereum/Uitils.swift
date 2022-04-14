import Foundation
import BigInt
import SwiftKeccak
import secp256k1

enum Utils {
    
    public static func ethFromWei(_ wei: String) -> String {
        
        var eth = "0."
        
        if wei.count < 18 {
            let zerosLeft = String(repeating: "0", count: 18 - wei.count)
            eth.append(contentsOf: zerosLeft + wei)
        } else {
            let unsignedIndex = wei.index(wei.startIndex, offsetBy: wei.count - 18)
            let unsigned = wei[wei.startIndex..<unsignedIndex]
            let other = String(wei[unsignedIndex...])
            eth.append(contentsOf: other)
            eth.removeFirst()
            eth = unsigned + eth
        }
        
        return eth
    }
    
    public static func weiFromEth(_ eth: String) -> String {
        let valueAfterDotStartIndex = eth.index(eth.startIndex, offsetBy: 2)
        let valueAfterDot = eth[valueAfterDotStartIndex...]
        
        var counterOfZeros = 0
        var isBeforeNum = true
        var wei = ""
        for char in valueAfterDot {
            if isBeforeNum {
                if char == "0" {
                    counterOfZeros += 1
                    
                } else {
                    isBeforeNum = false
                    wei += String(char)
                }
            }
            
            wei += String(char)
        }
        
        let zeros = String(repeating: "0", count: counterOfZeros)
        
        wei += zeros
        
        return wei
    }
    
    public static func getPublicKey(from privateKey: String) throws -> String {
        
        let privateKeyBytes = try privateKey.lowercased().removeHexPrefix().bytes
        
        let secp256k1PrivateKey = try secp256k1.Signing.PrivateKey(rawRepresentation: privateKeyBytes, format: .uncompressed)
        
        let publicKey = secp256k1PrivateKey.publicKey.rawRepresentation.subdata(in: 1..<65)
        
        return String(bytes: publicKey)
    }
    
    public static func getEthereumAddress(from publicKey: String) throws -> String {
        
        let publicKeyBytes = try publicKey.lowercased().bytes
        
        let publicKeyData = Data(bytes: publicKeyBytes, count: 64)
        
        let hash = publicKeyData.keccak()
        
        let address = hash.subdata(in: 12..<hash.count)
        
        let ethereumAddress = String(bytes: address).addHexPrefix()
        
        return ethereumAddress
    }
    
    public static func sign(data: Data, with privateKey: String) throws -> Signature {
        
        let privateKeyBytes = try privateKey.lowercased().removeHexPrefix().bytes
        
        let secp256k1PrivateKey = try secp256k1.Signing.PrivateKey(rawRepresentation: privateKeyBytes, format: .uncompressed)
        
        // MARK: - Make use of simplified syntax
        
        //        let keccakData = data.keccak()
        //
        //        let digests = SHA256.convert(keccakData.bytes)
        //
        //        let signature = try secp256k1PrivateKey.ecdsa.signature(for: digests)
        //
        
        guard let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY)) else {
            print("Failed to sign message: invalid context.")
            throw JSONRPCError.errorSigningTransaction
        }
        
        defer {
            secp256k1_context_destroy(context)
        }
        
        let keccakData = data.keccak()
        
        let keccakDataPointer = (keccakData as NSData).bytes.assumingMemoryBound(to: UInt8.self)
        
        let privateKeyPointer = (secp256k1PrivateKey.rawRepresentation as NSData).bytes.assumingMemoryBound(to: UInt8.self)
        
        let signaturePointer = UnsafeMutablePointer<secp256k1_ecdsa_recoverable_signature>.allocate(capacity: 1)
        
        defer {
            signaturePointer.deallocate()
        }
        
        guard secp256k1_ecdsa_sign_recoverable(context, signaturePointer, keccakDataPointer, privateKeyPointer, nil, nil) == 1 else {
            print("Failed to sign message: recoverable ECDSA signature creation failed.")
            throw JSONRPCError.errorSigningTransaction
        }
        
        let outputDataPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
        
        defer {
            outputDataPointer.deallocate()
        }
        
        var recoverableID: Int32 = 0
        
        secp256k1_ecdsa_recoverable_signature_serialize_compact(context, outputDataPointer, &recoverableID, signaturePointer)
        
        let outputWithRecoverableIDPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 65)
        
        defer {
            outputWithRecoverableIDPointer.deallocate()
        }
        
        outputWithRecoverableIDPointer.assign(from: outputDataPointer, count: 64)
        outputWithRecoverableIDPointer.advanced(by: 64).pointee = UInt8(recoverableID)
        
        let signedData = Data(bytes: outputWithRecoverableIDPointer, count: 65)
        
        let signature = Signature(signedData)
        
        return signature
    }
    
}

extension String {
    
    func removeHexPrefix() -> String {
        if self.hasPrefix("0x") {
            let index = self.index(self.startIndex, offsetBy: 2)
            return String(self[index...])
        }
        return self
    }
    
    func addHexPrefix() -> String {
        
        if self.hasPrefix("0x") {
            return self
        }
        
        return "0x" + self
    }
}
