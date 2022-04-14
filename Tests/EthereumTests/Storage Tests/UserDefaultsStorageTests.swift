import XCTest
@testable import Ethereum

class UserDefaultsStorageTests: XCTestCase {

    let storage = UserDefaultsStorage(password: "password")

    func testStorePrivateKey() throws {
        
        let privateKey = "95310e470942b7429f39243bbad4a0aa134eecb7d1e029a3b778b18ffa38259a"
        
        try storage.storePrivateKey(privateKey)
        
    }
    
    func testGetPrivateKeyTest() throws {
        
        let privateKey = "95310e470942b7429f39243bbad4a0aa134eecb7d1e029a3b778b18ffa38259a"
        
        let address = "0xf4053f6c8626f22398778267e46e0bf4179d78f6"
        
        let retrievedPrivateKey = try storage.getPrivateKey(for: address)
        
        XCTAssertEqual(privateKey, retrievedPrivateKey)
    }
    
    func testRemovePrivateKey() throws {
        
        let address = "0xf4053f6c8626f22398778267e46e0bf4179d78f6"
        
        try storage.removePrivateKey(for: address)
        
    }
    
}
