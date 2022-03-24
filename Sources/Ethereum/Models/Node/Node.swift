import Foundation

// TODO: Make default nodes
public enum DefaultNodes {
    public static let mainnet = Node(url: URL(string: "https://speedy-nodes-nyc.moralis.io/b383c412901116039315dd16/eth/mainnet")!)
    public static let ropsten = Node(url: URL(string: "https://speedy-nodes-nyc.moralis.io/b383c412901116039315dd16/eth/ropsten")!)
    public static let rinkeby = Node(url: URL(string: "https://speedy-nodes-nyc.moralis.io/b383c412901116039315dd16/eth/rinkeby")!)
    public static let kovan = Node(url: URL(string: "https://speedy-nodes-nyc.moralis.io/b383c412901116039315dd16/eth/kovan")!)
    public static let goerli = Node(url: URL(string: "https://speedy-nodes-nyc.moralis.io/b383c412901116039315dd16/eth/goerli")!)
}

public struct Node {
    
    // MARK: - Net
    
    public let url: URL
    
    public func version(completion: @escaping (JSONRPCError?, Int?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .version, params: Optional<String>.none, id: 10)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(JSONRPCError.errorEncodingJSONRPC, nil)
            return
        }
        
        Provider(node: self).sendRequest(jsonRPCData: jsonRPCData) { error, data in
            
            guard let data = data, error == nil else {
                completion(JSONRPCError.nilResponse, nil)
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<Int>.self, from: data) else {
                completion(JSONRPCError.errorDecodingJSONRPC, nil)
                return
            }
            
            let version = jsonRPCResponse.result
            
            completion(nil, version)
        }
        
    }
    
    public func listening() {
        
    }
    
    public func peerCount() {
        
    }
    
    // MARK: - Web3
    
    public func clientVersion() {
        
    }
    
     func sha3() {
        
    }
}


