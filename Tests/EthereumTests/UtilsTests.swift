import XCTest
import BigInt
@testable import Ethereum

class UtilsTests: XCTestCase {
    
    func testGetPublicKey() throws {
        let privateKey = "95310e470942b7429f39243bbad4a0aa134eecb7d1e029a3b778b18ffa38259a"
        
        let rightPublicKey = "94c9240ed8835b95856726d483cb14552208fb0fdcf305807b641a77e2dcbfb019941493cbe0cd5798f9b4048e3fdd742fd6549a5af26b038846ea96327fed05"
        
        let publicKey = try Utils.KeyUtils.getPublicKey(from: privateKey)
        
        XCTAssertEqual(publicKey, rightPublicKey)
    }
    
    func testGetEthereumAddress() throws {
        let publicKey = "94c9240ed8835b95856726d483cb14552208fb0fdcf305807b641a77e2dcbfb019941493cbe0cd5798f9b4048e3fdd742fd6549a5af26b038846ea96327fed05"
        
        let rightEthereumAddress = "0xf4053f6c8626f22398778267e46e0bf4179d78f6".lowercased()
        
        let ethereumAddress = try Utils.KeyUtils.getEthereumAddress(from: publicKey)
        
        XCTAssertEqual(ethereumAddress, rightEthereumAddress)
    }
    
    func testEthFromWei() throws {
        
        let wei = "12345678901234567890"
        let eth = Utils.Converter.convert(value: wei, from: .wei, to: .eth)
        let rightEth = "12.34567890123456789"
        
        XCTAssertEqual(eth, rightEth)
    }
    
    func testWeiFromEth() {
        
        let eth = "123.00000003"
        let wei = Utils.Converter.convert(value: eth, from: .eth, to: .wei)
        let rightWei = "123000000030000000000"
        
        XCTAssertEqual(wei, rightWei)
    }
    
    func testEthFromGwei() {
        
        let gwei = "121312100"
        let eth = Utils.Converter.convert(value: gwei, from: .gwei, to: .eth)
        let rightEth = "0.1213121"
        
        XCTAssertEqual(eth, rightEth)
    }
    
    func testFormatter() throws {
        
        let priceString = Utils.Formatter.currencyFormatter.string(from: 9999.99)!
        print(priceString)
    }
    
}
