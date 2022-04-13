//
//  File.swift
//  
//
//  Created by Ertem Biyik on 10.04.2022.
//

import Foundation
import CommonCrypto

struct AES {

    private let iv: Data

    init() {
        
        let randomBytes = Data(0...16).map { _ in UInt32.random(in: 0...UInt32.max) }
        
        let ivData = Data(bytes: randomBytes, count: 16)

        self.iv  = ivData
    }

    func encrypt(string: String, password: String) throws -> Data {
        
        let keyData = password.keccak()
        
        guard keyData.count == kCCKeySizeAES256 else {
            throw AESError.invalidPasswordLength
        }
        
        let bytes = try string.bytes
        
        let data = Data(bytes)
        
        return try crypt(data: data, option: CCOperation(kCCEncrypt), key: keyData)
    }

    func decrypt(data: Data, password: String) throws -> String {
        
        let keyData = password.keccak()
        
        guard keyData.count == kCCKeySizeAES256 else {
            throw AESError.invalidPasswordLength
        }
        
        let decryptedData = try crypt(data: data, option: CCOperation(kCCDecrypt), key: keyData)
        
        let value = String(bytes: decryptedData)
        
        return value
    }

    func crypt(data: Data, option: CCOperation, key: Data) throws -> Data {

        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData = Data(count: cryptLength)

        let keyLength = key.count
        let options = CCOptions(kCCOptionPKCS7Padding)

        var bytesLength = Int(0)

        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                    CCCrypt(option,
                            CCAlgorithm(kCCAlgorithmAES),
                            options,
                            keyBytes.baseAddress,
                            keyLength,
                            ivBytes.baseAddress,
                            dataBytes.baseAddress,
                            data.count,
                            cryptBytes.baseAddress,
                            cryptLength,
                            &bytesLength)
                    }
                }
            }
        }

        guard UInt32(status) == UInt32(kCCSuccess) else {
            throw AESError.errorCrypting
        }

        cryptData.removeSubrange(bytesLength..<cryptData.count)
        
        return cryptData
    }
    
    enum AESError: Error {
        case errorCrypting
        case invalidPasswordLength
    }
}
