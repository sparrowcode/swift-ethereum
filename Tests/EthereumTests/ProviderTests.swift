import XCTest
@testable import Ethereum

class ProviderTests: XCTestCase {
    
    let mainnetNodeURL = URL(string: "https://speedy-nodes-nyc.moralis.io/b383c412901116039315dd16/eth/mainnet")!
    
    let rinkebyNodeURL = URL(string: "https://speedy-nodes-nyc.moralis.io/b383c412901116039315dd16/eth/rinkeby")!
    
    var node: Node!
    var provider: Provider?
    
    override func setUpWithError() throws {
        self.node = try Node(url: "https://mainnet.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")
        self.provider = Provider(node: node)
    }
    
    func testSendRequest() async throws {
        
        let address = "0xb5bfc95C7345c8B20e5290D21f88a602580a08AB"
        
        do {
            let _ = try await provider?.sendRequest(method: .getBalance, params: [address, "latest"], decodeTo: String.self)
        } catch {
            XCTFail("\(error)", file: #filePath, line: #line)
        }
    }
    
    func testSendRequest2() async throws {
        
        let params = [String]()
        
        do {
            let _ = try await provider?.sendRequest(method: .version, params: params, decodeTo: String.self)
        } catch {
            XCTFail("\(error)", file: #filePath, line: #line)
        }
    }
}
