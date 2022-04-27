import XCTest
@testable import Ethereum

class UtilsTests: XCTestCase {
    
    func testGetPublicKey() throws {
        let privateKey = "95310e470942b7429f39243bbad4a0aa134eecb7d1e029a3b778b18ffa38259a"
        
        let rightPublicKey = "94c9240ed8835b95856726d483cb14552208fb0fdcf305807b641a77e2dcbfb019941493cbe0cd5798f9b4048e3fdd742fd6549a5af26b038846ea96327fed05"
        
        let publicKey = try Utils.getPublicKey(from: privateKey)
        
        XCTAssertEqual(publicKey, rightPublicKey)
    }
    
    func testGetEthereumAddress() throws {
        let publicKey = "94c9240ed8835b95856726d483cb14552208fb0fdcf305807b641a77e2dcbfb019941493cbe0cd5798f9b4048e3fdd742fd6549a5af26b038846ea96327fed05"
        
        let rightEthereumAddress = "0xf4053f6c8626f22398778267e46e0bf4179d78f6".lowercased()
        
        let ethereumAddress = try Utils.getEthereumAddress(from: publicKey)
        
        XCTAssertEqual(ethereumAddress, rightEthereumAddress)
    }
    
    func testEthFromWei() throws {
        
        let wei = "12345678901234567890"
        let eth = Utils.ethFromWei(wei)
        let rightEth = "12.34567890123456789"
        
        XCTAssertEqual(eth, rightEth)
    }
    
    func testWeiFromEth() {
        
        let eth = "12.34567890123456789"
        let wei = Utils.weiFromEth(eth)
        let rightWei = "12345678901234567890"
        
        //XCTAssertEqual(wei, rightWei)
    }
    
}
