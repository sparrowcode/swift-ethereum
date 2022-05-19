import Foundation

public enum NodeErrors: Error {
    case errorRetrievingChainID
    case invalidURL
}

public struct Node {
    
    public static let mainnet = Node(url: URL(string: "https://mainnet.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!, network: .mainnet)
    public static let ropsten = Node(url: URL(string: "https://ropsten.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!, network: .ropsten)
    public static let rinkeby = Node(url: URL(string: "https://rinkeby.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!, network: .rinkeby)
    public static let kovan = Node(url: URL(string: "https://kovan.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!, network: .kovan)
    public static let goerli = Node(url: URL(string: "https://goerli.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!, network: .goerli)
    
    public let url: URL
    
    public var network: Network
    
    private var provider: Provider?
    
    public init(url: String) throws {
        
        guard let url = URL(string: url) else {
            throw NodeErrors.invalidURL
        }
        
        self.url = url
        self.network = .custom(0)
        
        configureProvider()
        
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
        configureProvider()
    }
    
    private mutating func configureProvider() {
        self.provider = Provider(node: self)
    }
    
    
    // MARK: - Net
    public func version(completion: @escaping (Int?, Error?) -> Void) {
        
        let params = [String]()
        
        provider?.sendRequest(method: .version, params: params, decodeTo: String.self) { version, error in
            
            guard let version = version, error == nil else {
                completion(nil, error)
                return
            }
            
            guard let intVersion = Int(version) else {
                completion(nil, ResponseError.errorDecodingJSONRPC)
                return
            }
            
            completion(intVersion, nil)
            
        }
        
    }
    
    public func listening(completion: @escaping (Bool?, Error?) -> Void) {
        
        let params = [String]()
        
        provider?.sendRequest(method: .listening, params: params, decodeTo: Bool.self) { isListening, error in
            
            guard let isListening = isListening, error == nil else {
                completion(nil, error)
                return
            }
            
            completion(isListening, nil)
        }
    }
    
    public func peerCount(completion: @escaping (Int?, Error?) -> Void) {
        
        let params = [String]()
        
        provider?.sendRequest(method: .peerCount, params: params, decodeTo: String.self) { hexPeerCount, error in
            
            guard let hexPeerCount = hexPeerCount, error == nil else {
                completion(nil, error)
                return
            }
            
            let peerCount = Int(hexPeerCount.removeHexPrefix(), radix: 16)
            
            completion(peerCount, nil)
            
        }
        
    }
    
    // MARK: - Web3
    
    public func clientVersion(completion: @escaping (String?, Error?) -> Void) {
        
        let params = [String]()
        
        provider?.sendRequest(method: .clientVersion, params: params, decodeTo: String.self) { clientVersion, error in
            
            guard let clientVersion = clientVersion, error == nil else {
                completion(nil, error)
                return
            }
            
            completion(clientVersion, nil)
        }
        
    }
}


extension Node: Equatable {
    public static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.url == rhs.url && lhs.network == rhs.network
    }
}
