import Foundation
import BigInt

enum RLPEncoder {
    
    static func encode(_ array: [RLPEncodable]) throws -> Data {
        
        var encodedData = Data()
        
        for element in array {
            
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
    
    private static func encodeHeader(size: UInt64, smallTag: UInt8, largeTag: UInt8) -> Data {
        
        if size < 56 {
            return Data([smallTag + UInt8(size)])
        }
        
        let sizeData = bigEndianBinary(size)
        
        var encoded = Data()
        
        encoded.append(largeTag + UInt8(sizeData.count))
        encoded.append(contentsOf: sizeData)
        
        return encoded
    }
    
    private static func bigEndianBinary(_ i: UInt64) -> Data {
        
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
