import Foundation

// TODO: Make default nodes
public enum DefaultNodes {
    public static var mainnet = Node(url: URL(string: "https://mainnet.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!)
    public static let ropsten = Node(url: URL(string: "https://ropsten.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!)
    public static let rinkeby = Node(url: URL(string: "https://rinkeby.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!)
    public static let kovan = Node(url: URL(string: "https://kovan.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!)
    public static let goerli = Node(url: URL(string: "https://goerli.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!)
}

public struct Node {
    
    // MARK: - Net
    
    public let url: URL
    
    public func version(completion: @escaping (JSONRPCError?, String?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .version, params: [Optional<String>.none], id: 20)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(.errorEncodingJSONRPC, nil)
            return
        }
        
        var provider: Provider? = Provider(node: self)
        
        provider?.sendRequest(jsonRPCData: jsonRPCData) { error, data in
            
            guard let data = data, error == nil else {
                completion(.nilResponse, nil)
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(.errorDecodingJSONRPC, nil)
                return
            }
            
            let version = jsonRPCResponse.result
            
            completion(nil, version)
            
            provider = nil
        }
    }
    
    public func listening(completion: @escaping (JSONRPCError?, Bool?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .listening, params: Optional<String>.none, id: 21)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(.errorEncodingJSONRPC, nil)
            return
        }
        
        var provider: Provider? = Provider(node: self)
        
        provider?.sendRequest(jsonRPCData: jsonRPCData) { error, data in
            
            guard let data = data, error == nil else {
                completion(.nilResponse, nil)
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<Bool>.self, from: data) else {
                completion(.errorDecodingJSONRPC, nil)
                return
            }
            
            let version = jsonRPCResponse.result
            
            completion(nil, version)
            
            provider = nil
        }
    }
    
    public func peerCount(completion: @escaping (JSONRPCError?, Int?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .peerCount, params: Optional<String>.none, id: 22)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(.errorEncodingJSONRPC, nil)
            return
        }
        
        var provider: Provider? = Provider(node: self)
        
        provider?.sendRequest(jsonRPCData: jsonRPCData) { error, data in
            
            guard let data = data, error == nil else {
                completion(.nilResponse, nil)
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(.errorDecodingJSONRPC, nil)
                return
            }
            
            let hexPeerCount = jsonRPCResponse.result.replacingOccurrences(of: "0x", with: "")
            
            let peerCount = Int(hexPeerCount, radix: 16)
            
            completion(nil, peerCount)
            
            provider = nil
        }
    }
    
    // MARK: - Web3
    
    public func clientVersion(completion: @escaping (JSONRPCError?, String?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .clientVersion, params: Optional<String>.none, id: 23)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(.errorEncodingJSONRPC, nil)
            return
        }
        
        var provider: Provider? = Provider(node: self)
        
        provider?.sendRequest(jsonRPCData: jsonRPCData) { error, data in
            
            guard let data = data, error == nil else {
                completion(.nilResponse, nil)
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(.errorDecodingJSONRPC, nil)
                return
            }
            
            let clientVersion = jsonRPCResponse.result
            
            completion(nil, clientVersion)
            
            provider = nil
        }
    }
    
    public func sha3(value: String, completion: @escaping (JSONRPCError?, String?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .sha3, params: [value], id: 24)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(.errorEncodingJSONRPC, nil)
            return
        }
        
        var provider: Provider? = Provider(node: self)
        
        provider?.sendRequest(jsonRPCData: jsonRPCData) { error, data in
            
            guard let data = data, error == nil else {
                completion(.nilResponse, nil)
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(.errorDecodingJSONRPC, nil)
                return
            }
            
            let sha3 = jsonRPCResponse.result
            
            completion(nil, sha3)
            
            provider = nil
        }
    }
}


