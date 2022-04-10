//
//  File.swift
//  
//
//  Created by Ertem Biyik on 10.04.2022.
//

import Foundation
import CommonCrypto

struct AES {
    
    // MARK: - Make (or think about) default initial vector

    private let key: Data
    private let iv: Data

    init(password: String, iv: String) throws {
        
        let keyData = password.keccak()
        
        guard keyData.count == kCCKeySizeAES256 else {
            throw AESError.invalidPasswordLength
        }

        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            throw AESError.invalidInitialVectorLength
        }

        self.key = keyData
        self.iv  = ivData
    }

    func encrypt(string: String) throws -> Data {
        
        guard let data = string.data(using: .utf8) else { throw AESError.invalidString }
        
        return try crypt(data: data, option: CCOperation(kCCEncrypt))
    }

    func decrypt(data: Data) throws -> String {
        
        let decryptedData = try crypt(data: data, option: CCOperation(kCCDecrypt))
        
        guard let value = String(bytes: decryptedData, encoding: .utf8) else {
            throw AESError.unableToConvertToStringValue
        }
        return value
    }

    func crypt(data: Data, option: CCOperation) throws -> Data {

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
        case invalidString
        case unableToConvertToStringValue
        case errorCrypting
        case invalidPasswordLength
        case invalidInitialVectorLength
    }
}
