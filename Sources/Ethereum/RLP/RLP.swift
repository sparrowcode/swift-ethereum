import Foundation
import BigInt

enum RLP {
    
    static func encode(_ item: RLPItem) -> Data? {
        switch item {
        case .int(let value):
            return encode(int: value)
        case .string(let value):
            return encode(string: value)
        case .bigInt(let value):
            return encode(bigInt: value)
        case .array(let value):
            return encode(array: value)
        case .bigUInt(let value):
            return encode(bigUInt: value)
        case .data(let value):
            return encode(data: value)
        }
    }
    
    static func encode(string: String) -> Data? {
        
        if let bytesArray = try? string.bytes {
            let hexData = Data(bytesArray)
            return encode(data: hexData)
        }
        
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        return encode(data: data)
    }
    
    static func encode(int: Int) -> Data? {
        guard int >= 0 else {
            return nil
        }
        return encode(bigInt: BigInt(int))
    }
    
    static func encode(bigInt: BigInt) -> Data? {
        guard bigInt >= 0 else {
            return nil
        }
        return encode(bigUInt: BigUInt(bigInt))
    }
    
    static func encode(bigUInt: BigUInt) -> Data? {
        let data = bigUInt.serialize()
        
        let lastIndex = data.count - 1
        let firstIndex = data.firstIndex(where: {$0 != 0x00}) ?? lastIndex
        if lastIndex == -1 {
            return Data( [0x80])
        }
        let subdata = data.subdata(in: firstIndex..<lastIndex+1)
        
        if subdata.count == 1 && subdata[0] == 0x00 {
            return Data( [0x80])
        }
        
        return encode(data: data.subdata(in: firstIndex..<lastIndex+1))
    }
    
    static func encode(data: Data) -> Data {
        if data.count == 1 && data[0] <= 0x7f {
            return data // single byte, no header
        }
        
        var encoded = encodeHeader(size: UInt64(data.count), smallTag: 0x80, largeTag: 0xb7)
        encoded.append(data)
        return encoded
    }
    
    static func encode(array: [RLPItem]) -> Data? {
        var encodedData = Data()
        for element in array {
            guard let encoded = encode(element) else {
                return nil
            }
            encodedData.append(encoded)
        }
        
        var encoded = encodeHeader(size: UInt64(encodedData.count), smallTag: 0xc0, largeTag: 0xf7)
        encoded.append(encodedData)
        return encoded
    }
    
    static func encodeHeader(size: UInt64, smallTag: UInt8, largeTag: UInt8) -> Data {
        if size < 56 {
            return Data([smallTag + UInt8(size)])
        }
        
        let sizeData = bigEndianBinary(size)
        var encoded = Data()
        encoded.append(largeTag + UInt8(sizeData.count))
        encoded.append(contentsOf: sizeData)
        return encoded
    }
    
    // in Ethereum integers must be represented in big endian binary form with no leading zeroes
    static func bigEndianBinary(_ i: UInt64) -> Data {
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
