import Foundation

public enum NodeErrors: Error {
    case errorRetrievingChainID
    case invalidURL
}

public struct Node {
    
    public static var mainnet = Node(url: URL(string: "https://mainnet.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!, network: .mainnet)
    public static let ropsten = Node(url: URL(string: "https://ropsten.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!, network: .ropsten)
    public static let rinkeby = Node(url: URL(string: "https://rinkeby.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!, network: .rinkeby)
    public static let kovan = Node(url: URL(string: "https://kovan.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!, network: .kovan)
    public static let goerli = Node(url: URL(string: "https://goerli.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!, network: .goerli)
    
    public let url: URL
    
    public var network: Network
    
    public init(url: String) throws {
        
        guard let url = URL(string: url) else {
            throw NodeErrors.invalidURL
        }
        
        self.url = url
        self.network = .custom(0)
        
        var chainID: Int?
        var localError: Error?
        
        let group = DispatchGroup()
        group.enter()
        
        self.version { version, error in
            chainID = version
            localError = error
            group.leave()
        }
        
        group.wait()
        
        guard localError == nil, let chainID = chainID else {
            throw localError ?? NodeErrors.errorRetrievingChainID
        }
        
        for net in Network.allCases {
            if net.chainID == chainID {
                self.network = net
                return
            }
        }
        
        self.network = .custom(chainID)
        
    }
    
    private init(url: URL, network: Network) {
        self.url = url
        self.network = network
    }
    
    
    // MARK: - Net
    public func version(completion: @escaping (Int?, JSONRPCError?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .version, params: [Optional<String>.none], id: 20)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        let provider = Provider(node: self)
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let version = jsonRPCResponse.result
            
            guard let intVersion = Int(version) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            completion(intVersion, nil)
            
        }
    }
    
    public func listening(completion: @escaping (Bool?, JSONRPCError?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .listening, params: Optional<String>.none, id: 21)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        let provider = Provider(node: self)
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<Bool>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let version = jsonRPCResponse.result
            
            completion(version, nil)
            
        }
    }
    
    public func peerCount(completion: @escaping (Int?, JSONRPCError?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .peerCount, params: Optional<String>.none, id: 22)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        let provider = Provider(node: self)
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let hexPeerCount = jsonRPCResponse.result.removeHexPrefix()
            
            let peerCount = Int(hexPeerCount, radix: 16)
            
            completion(peerCount, nil)
            
        }
    }
    
    // MARK: - Web3
    
    public func clientVersion(completion: @escaping (String?, JSONRPCError?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .clientVersion, params: Optional<String>.none, id: 23)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        let provider = Provider(node: self)
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let clientVersion = jsonRPCResponse.result
            
            completion(clientVersion, nil)
            
        }
    }
    
    public func sha3(value: String, completion: @escaping (String?, JSONRPCError?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .sha3, params: [value], id: 24)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        let provider = Provider(node: self)
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let sha3 = jsonRPCResponse.result
            
            completion(sha3, nil)
            
        }
    }
}


