import XCTest
import BigInt
import Ethereum

class ERC721Tests: XCTestCase {
    
    struct ERC721: EIP721 {
        var address: String
    }

    override func setUpWithError() throws {
        
    }

    func testBalance() throws {
        
        let expectation = XCTestExpectation(description: "get balance erc721")
        
        let erc721 = ERC721(address: "0xf8aD42AB76862A934AD2e4578C6a108B172Cd287")
        
        erc721.balance(of: "0x495f947276749ce646f68ac8c248420045cb7b5e") { value, error in
            XCTAssertNil(error)
            XCTAssertNotNil(value)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
    }

    func testOwnerOf() throws {
        
        let expectation = XCTestExpectation(description: "get owner of erc721")
        
        let erc721 = ERC721(address: "0xf8aD42AB76862A934AD2e4578C6a108B172Cd287")
        
        let tokenId = BigUInt(708)
        
        erc721.owner(of: tokenId) { value, error in
            XCTAssertNil(error)
            XCTAssertNotNil(value)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
    }
    
    func testName() throws {
        
        let expectation = XCTestExpectation(description: "get name erc721")
        
        let erc721 = ERC721(address: "0xf8aD42AB76862A934AD2e4578C6a108B172Cd287")
        
        erc721.name() { name, error in
            XCTAssertNil(error)
            XCTAssertNotNil(name)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
    }
    
    func testSymbol() throws {
        
        let expectation = XCTestExpectation(description: "get symbol erc721")
        
        let erc721 = ERC721(address: "0xf8aD42AB76862A934AD2e4578C6a108B172Cd287")
        
        erc721.symbol() { symbol, error in
            XCTAssertNil(error)
            XCTAssertNotNil(symbol)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
        
    }
    
    func testTokenURI() throws {
        
        let expectation = XCTestExpectation(description: "get tokenURI of erc721")
        
        let erc721 = ERC721(address: "0xf8aD42AB76862A934AD2e4578C6a108B172Cd287")
        
        let tokenId = BigUInt(708)
        
        erc721.tokenURI(tokenID: tokenId) { tokenURI, error in
            XCTAssertNil(error)
            XCTAssertNotNil(tokenURI)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
    }
    
    func testTotalSupply() throws {
        
        let expectation = XCTestExpectation(description: "total supply of erc721")
        
        let erc721 = ERC721(address: "0xf8aD42AB76862A934AD2e4578C6a108B172Cd287")
        
        erc721.totalSupply() { totalSupply, error in
            XCTAssertNil(error)
            XCTAssertNotNil(totalSupply)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
    }
}
