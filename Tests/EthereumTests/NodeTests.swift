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
        
        do {
            let _ = try await node.version()
        } catch {
            XCTFail("\(error)", file: #filePath, line: #line)
        }
    }
    
    func testListening() async throws {
        
        do {
            let _ = try await node.listening()
        } catch {
            XCTFail("\(error)", file: #filePath, line: #line)
        }
    }
    
    func testPeerCount() async throws {
        
        do {
            let _ = try await node.peerCount()
        } catch {
            XCTFail("\(error)", file: #filePath, line: #line)
        }
    }
    
    func testClientVersion() async throws {
        
        do {
            let _ = try await node.clientVersion()
        } catch {
            XCTFail("\(error)", file: #filePath, line: #line)
        }
    }
}
