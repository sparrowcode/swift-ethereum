import Foundation
import BigInt

public protocol RLPEncodable {
    func encodeRLP() throws -> Data
}

enum RLPEncoderError: Error {
    case unvalidString
    case negativeInteger
}

extension String: RLPEncodable {
    
    public func encodeRLP() throws -> Data {
        
        if let bytesArray = try? self.bytes {
            let hexData = Data(bytesArray)
            return try hexData.encodeRLP()
        }
        
        guard let data = self.data(using: .utf8) else {
            throw RLPEncoderError.unvalidString
        }
        
        return try data.encodeRLP()
    }
    
    func decodeRLP() throws -> Data {
        return Data()
    }
    
}

extension Int: RLPEncodable {
    
    public func encodeRLP() throws -> Data {
        
        guard self >= 0 else {
            throw RLPEncoderError.negativeInteger
        }
        
        return try BigInt(self).encodeRLP()
    }
    
    func decodeRLP() throws -> Data {
        return Data()
    }
    
    
}

extension BigInt: RLPEncodable {
    
    public func encodeRLP() throws -> Data {
        
        guard self >= 0 else {
            throw RLPEncoderError.negativeInteger
        }
        
        return try BigUInt(self).encodeRLP()
    }
    
    func decodeRLP() throws -> Data {
        return Data()
    }
    
    
}

extension BigUInt: RLPEncodable {
    
    public func encodeRLP() throws -> Data {
        
        let data = self.serialize()
        
        let lastIndex = data.count - 1
        
        let firstIndex = data.firstIndex(where: { $0 != 0x00 } ) ?? lastIndex
        
        if lastIndex == -1 {
            return Data( [0x80])
        }
        
        let subdata = data.subdata(in: firstIndex..<lastIndex+1)
        
        if subdata.count == 1 && subdata[0] == 0x00 {
            return Data( [0x80])
        }
        
        return try data.subdata(in: firstIndex..<lastIndex+1).encodeRLP()
        
    }
    
    func decodeRLP() throws -> Data {
        return Data()
    }
}

extension Data: RLPEncodable {
    
    public func encodeRLP() throws -> Data {
        
        if self.count == 1 && self[0] <= 0x7f {
            return self // single byte, no header
        }
        
        var encoded = encodeHeader(size: UInt64(self.count), smallTag: 0x80, largeTag: 0xb7)
        
        encoded.append(self)
        
        return encoded
    }
    
    func decodeRLP() throws -> Data {
        return Data()
    }
}

extension Array: RLPEncodable where Element: RLPEncodable {
    
    public func encodeRLP() throws -> Data {
        
        var encodedData = Data()
        
        for element in self {
            do {
                let encoded = try element.encodeRLP()
                encodedData.append(encoded)
            } catch {
                throw error
            }
        }
        
        var encoded = encodeHeader(size: UInt64(encodedData.count), smallTag: 0xc0, largeTag: 0xf7)
        
        encoded.append(encodedData)
        
        return encoded
    }
    
    func decodeRLP() throws -> Data {
        return Data()
    }
}

extension RLPEncodable {
    
    func encodeHeader(size: UInt64, smallTag: UInt8, largeTag: UInt8) -> Data {
        
        if size < 56 {
            return Data([smallTag + UInt8(size)])
        }
        
        let sizeData = bigEndianBinary(size)
        
        var encoded = Data()
        
        encoded.append(largeTag + UInt8(sizeData.count))
        encoded.append(contentsOf: sizeData)
        
        return encoded
    }
    
    func bigEndianBinary(_ i: UInt64) -> Data {
        
        var value = i
        
        var bytes = withUnsafeBytes(of: &value) { Array($0) }
        
        for (index, byte) in bytes.enumerated().reversed() {
            if index != 0 && byte == 0x00 {
                bytes.remove(at: index)
            } else {
                break
            }
        }
        
        return Data(bytes.reversed())
    }
}
