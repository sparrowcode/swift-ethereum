import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum NodeErrors: Error {
    case errorRetrievingChainID
    case invalidURL
}

public struct Node {
    
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
            
            defer { group.leave() }
            
            chainID = version
            localError = error
        }
        
        // MARK: - Blocks thread, maybe switch to notify
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

extension Node {
    
    public func version() async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            version() { value, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let value = value {
                    continuation.resume(returning: value)
                }
            }
        }
    }
    
    public func listening() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            listening() { value, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let value = value {
                    continuation.resume(returning: value)
                }
            }
        }
    }
    
    public func peerCount() async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            peerCount() { value, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let value = value {
                    continuation.resume(returning: value)
                }
            }
        }
    }
    
    public func clientVersion() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            clientVersion() { value, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let value = value {
                    continuation.resume(returning: value)
                }
            }
        }
    }
}

