import XCTest
import Ethereum

class NodeTests: XCTestCase {
    
    var node: Node!
    
    override func setUpWithError() throws {
        self.node = try Node(url: "https://mainnet.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")
    }
    
    func testInitialiseCustomNode() throws {
        
        let url = "https://mainnet.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee"
        
        let node = try Node(url: url)
        
        let network = node.network
        
        XCTAssertEqual(network, Network.mainnet)
    }
    
    func testVersion() async throws {
        
        let _ = try await node.version()
    }
    
    func testListening() async throws {
        
        let _ = try await node.listening()
    }
    
    func testPeerCount() async throws {
        
        let _ = try await node.peerCount()
    }
    
    func testClientVersion() async throws {
        
        let _ = try await node.clientVersion()
    }
}
