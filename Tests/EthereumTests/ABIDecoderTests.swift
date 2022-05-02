import XCTest
import BigInt
@testable import Ethereum

class ABIDecoderTests: XCTestCase {

    
    func testDecodeEthereumAddress() throws {
        
        let ethereumAddress = EthereumAddress("0xE92A146f86fEda6D14Ee1dc1BfB620D3F3d1b873")
        
        let encoded = try ethereumAddress.encodeABI(isDynamic: false, sequenceElementType: .address)
        
        let decoded = try ABIDecoder.decode(encoded, to: .address) as? EthereumAddress
        
        XCTAssertEqual(ethereumAddress, decoded)
    }
    
    func testDecodeUInt() throws {
        
        let uint = BigUInt(1212112122)
        
        let encoded = try uint.encodeABI(isDynamic: false, sequenceElementType: .uint())
        
        let decoded = try ABIDecoder.decode(encoded, to: .uint()) as? BigUInt
        
        XCTAssertEqual(uint, decoded)
    }

    func testDecodeInt() throws {
        
        let int = BigInt(1212112122)
        
        let encoded = try int.encodeABI(isDynamic: false, sequenceElementType: .int())
        
        let decoded = try ABIDecoder.decode(encoded, to: .int()) as? BigInt
        
        XCTAssertEqual(int, decoded)
    }
    
    func testDecodeBool() throws {
        
        let bool = false
        
        let encoded = try bool.encodeABI(isDynamic: false, sequenceElementType: .bool)
        
        let decoded = try ABIDecoder.decode(encoded, to: .bool) as? Bool
        
        XCTAssertEqual(bool, decoded)
    }
    
    func testDecodeString() throws {
        
        let string = "hello"
        
        let encoded = try string.encodeABI(isDynamic: false, sequenceElementType: .string)
        
        let decoded = try ABIDecoder.decode(encoded, to: .string) as? String
        
        XCTAssertEqual(string, decoded)
    }
    
    func testDecodeBytes() throws {
        
        let bytes = "6876".data(using: .utf8)
        
        let encoded = try bytes!.encodeABI(isDynamic: false, sequenceElementType: .bytes(4))
        
        print(encoded)
        
        let decoded = try ABIDecoder.decode(encoded, to: .bytes()) as? Data
        
        XCTAssertEqual(bytes, decoded)
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
