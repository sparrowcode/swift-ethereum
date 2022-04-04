//
//  AccountManagerTests.swift
//  
//
//  Created by Ertem Biyik on 31.03.2022.
//

import XCTest
@testable import Ethereum

class AccountManagerTests: XCTestCase {
    
    func testGetPublicKey() throws {
        let privateKey = "95310e470942b7429f39243bbad4a0aa134eecb7d1e029a3b778b18ffa38259a"
        let rightPublicKey = "94c9240ed8835b95856726d483cb14552208fb0fdcf305807b641a77e2dcbfb019941493cbe0cd5798f9b4048e3fdd742fd6549a5af26b038846ea96327fed05"
        
        let publicKey = try AccountManager.getPublicKey(from: privateKey)
        
        XCTAssertEqual(publicKey, rightPublicKey)
    }
    
    func testGetEthereumAddress() throws {
        let publicKey = "94c9240ed8835b95856726d483cb14552208fb0fdcf305807b641a77e2dcbfb019941493cbe0cd5798f9b4048e3fdd742fd6549a5af26b038846ea96327fed05"
        let rightEthereumAddress = "0xf4053f6c8626f22398778267e46e0bf4179d78f6".lowercased()
        
        let ethereumAddress = try AccountManager.getEthereumAddress(from: publicKey)
        
        XCTAssertEqual(ethereumAddress, rightEthereumAddress)
    }
    
    func testCreateAccount() throws {
        let _ = try AccountManager.createAccount()
    }
    
    func testImportAccount() throws {
        let privateKey = "95310e470942b7429f39243bbad4a0aa134eecb7d1e029a3b778b18ffa38259a"
        
        let _ = try AccountManager.importAccount(privateKey: privateKey)
    }
}

extension Array where Element == UInt8 {
    init(hex: String) {
        self = Array<UInt8>()
        self.reserveCapacity(hex.unicodeScalars.underestimatedCount)
        var buffer: UInt8?
        var skip = hex.hasPrefix("0x") ? 2 : 0
        for char in hex.unicodeScalars.lazy {
            guard skip == 0 else {
                skip -= 1
                continue
            }
            guard char.value >= 48 && char.value <= 102 else {
                removeAll()
                return
            }
            let v: UInt8
            let c: UInt8 = UInt8(char.value)
            switch c {
            case let c where c <= 57:
                v = c - 48
            case let c where c >= 65 && c <= 70:
                v = c - 55
            case let c where c >= 97:
                v = c - 87
            default:
                removeAll()
                return
            }
            if let b = buffer {
                append(b << 4 | v)
                buffer = nil
            } else {
                buffer = v
            }
        }
        if let b = buffer {
            append(b)
        }
    }
}

extension String {
    func stripHexPrefix() -> String {
        if self.hasPrefix("0x") {
            let indexStart = self.index(self.startIndex, offsetBy: 2)
            return String(self[indexStart...])
        }
        return self
    }
}

extension Data {
    
    static func fromHex(_ hex: String) -> Data? {
        let string = hex.lowercased().stripHexPrefix()
        let array = Array<UInt8>(hex: string)
        if (array.count == 0) {
            if (hex == "0x" || hex == "") {
                return Data()
            } else {
                return nil
            }
        }
        return Data(array)
    }
}
