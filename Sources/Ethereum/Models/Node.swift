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
        self.version { result in
            
            defer { group.leave() }
            
            switch result {
            case .success(let version):
                chainID = version
            case .failure(let error):
                localError = error
            }
            
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
    public func version(completion: @escaping (Result<Int, Error>) -> ()) {
        
        let params = [String]()
        
        provider?.sendRequest(method: .version, params: params, decodeTo: String.self) { result in
            
            switch result {
            case .success(let version):
                if let intVersion = Int(version) {
                    completion(.success(intVersion))
                } else {
                    completion(.failure(ResponseError.errorDecodingJSONRPC))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func listening(completion: @escaping (Result<Bool, Error>) -> ()) {
        
        let params = [String]()
        
        provider?.sendRequest(method: .listening, params: params, decodeTo: Bool.self) { result in
            
            switch result {
            case .success(let isListening):
                completion(.success(isListening))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    public func peerCount(completion: @escaping (Result<Int, Error>) -> ()) {
        
        let params = [String]()
        
        provider?.sendRequest(method: .peerCount, params: params, decodeTo: String.self) { result in
            
            switch result {
            case .success(let hexPeerCount):
                if let peerCount = Int(hexPeerCount.removeHexPrefix(), radix: 16) {
                    completion(.success(peerCount))
                } else {
                    completion(.failure(ConvertingError.errorConvertingFromHex))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
        
    }
    
    // MARK: - Web3
    
    public func clientVersion(completion: @escaping (Result<String, Error>) -> ()) {
        
        let params = [String]()
        
        provider?.sendRequest(method: .clientVersion, params: params, decodeTo: String.self) { result in
            
            completion(result)
            
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
            version() { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func listening() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            listening() { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func peerCount() async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            peerCount() { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func clientVersion() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            clientVersion() { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

