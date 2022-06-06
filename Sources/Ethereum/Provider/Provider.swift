import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public final class Provider {
    
    public let node: Node
    
    private let session: URLSession
    
    private let encoder = JSONEncoder()
    
    private let decoder = JSONDecoder()
    
    private let queue = DispatchQueue(label: "com.swift-ethereum.provider", attributes: .concurrent)
    
    public init(node: Node, sessionConfiguration: URLSessionConfiguration) {
        self.node = node
        self.session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
    }
    
    public convenience init(node: Node) {
        self.init(node: node, sessionConfiguration: URLSession.shared.configuration)
    }
    
    deinit {
        self.session.finishTasksAndInvalidate()
    }
    
    /*
     Method that is called from Service to send a request
     */
    func sendRequest<E: Encodable, D: Decodable>(method: JSONRPCMethod, params: E, decodeTo: D.Type, completion: @escaping (Result<D, Error>) -> Void) {
        
        queue.async { [weak self] in
            
            guard let self = self else {
                completion(.failure(ProviderError.providerIsNil))
                return
            }
            
            var request = URLRequest(url: self.node.url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let id = Int.random(in: 1...1000)
            
            let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: method, params: params, id: id)
            
            guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
                completion(.failure(ResponseError.errorEncodingJSONRPC))
                return
            }
            
            request.httpBody = jsonRPCData
            
            let task = self.session.dataTask(with: request) { data, response, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(ResponseError.nilResponse))
                    return
                }
                
                if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError.self, from: data) {
                    completion(.failure(ResponseError.ethereumError(ethereumError.error)))
                    return
                }
                
                guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<D>.self, from: data) else {
                    completion(.failure(ResponseError.errorDecodingJSONRPC))
                    return
                }
                
                completion(.success(jsonRPCResponse.result))
            }
            task.resume()
        }
    }
}


extension Provider {
    func sendRequest<E: Encodable, D: Decodable>(method: JSONRPCMethod, params: E, decodeTo: D.Type) async throws -> D {
        return try await withCheckedThrowingContinuation { continuation in
            sendRequest(method: method, params: params, decodeTo: decodeTo) { result in
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

