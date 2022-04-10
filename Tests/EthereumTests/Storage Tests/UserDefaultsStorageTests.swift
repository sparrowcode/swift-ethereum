//
//  UserDefaultsStorageTests.swift
//  
//
//  Created by Ertem Biyik on 10.04.2022.
//

import XCTest
@testable import Ethereum

class UserDefaultsStorageTests: XCTestCase {

    let storage = UserDefaultsStorage()
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStorePrivateKey() throws {
        let privateKey = "95310e470942b7429f39243bbad4a0aa134eecb7d1e029a3b778b18ffa38259a"
        let password = "password"
        
        let address = "0xf4053f6c8626f22398778267e46e0bf4179d78f6"
        
        try storage.storePrivateKey(privateKey, password: password)
        
        let retrievedPrivateKey = try storage.getPrivateKey(for: address, password: password)
        
        XCTAssertEqual(privateKey, retrievedPrivateKey)
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
