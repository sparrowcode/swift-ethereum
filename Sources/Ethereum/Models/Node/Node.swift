import Foundation

public struct Node {
    
    public let url: URL
    
    private var provider: Provider?
    
    //public let network: Network
    
    public init(url: URL) {
        self.url = url
        configureProvider()
    }
    
    mutating func configureProvider() {
        self.provider = Provider(node: self)
    }
    
    // MARK: - Net
    public func version(completion: @escaping (JSONRPCError?, String?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .version, params: [Optional<String>.none], id: 20)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(.errorEncodingJSONRPC, nil)
            return
        }
        
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
            
        }
    }
    
    public func listening(completion: @escaping (JSONRPCError?, Bool?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .listening, params: Optional<String>.none, id: 21)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(.errorEncodingJSONRPC, nil)
            return
        }
        
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
            
        }
    }
    
    public func peerCount(completion: @escaping (JSONRPCError?, Int?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .peerCount, params: Optional<String>.none, id: 22)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(.errorEncodingJSONRPC, nil)
            return
        }
        
        provider?.sendRequest(jsonRPCData: jsonRPCData) { error, data in
            
            guard let data = data, error == nil else {
                completion(.nilResponse, nil)
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(.errorDecodingJSONRPC, nil)
                return
            }
            
            let hexPeerCount = jsonRPCResponse.result.removeHexPrefix()
            
            let peerCount = Int(hexPeerCount, radix: 16)
            
            completion(nil, peerCount)
            
        }
    }
    
    // MARK: - Web3
    
    public func clientVersion(completion: @escaping (JSONRPCError?, String?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .clientVersion, params: Optional<String>.none, id: 23)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(.errorEncodingJSONRPC, nil)
            return
        }
        
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
            
        }
    }
    
    public func sha3(value: String, completion: @escaping (JSONRPCError?, String?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .sha3, params: [value], id: 24)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(.errorEncodingJSONRPC, nil)
            return
        }
        
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
            
        }
    }
}


