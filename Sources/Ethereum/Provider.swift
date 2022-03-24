import Foundation

protocol ProviderProtocol {
    
    init(node: Node, sessionConfiguration: URLSessionConfiguration)
    init(node: Node)
    func sendRequest(jsonRPCData: Data, completion: @escaping (Error?, Data?) -> Void)
}

public final class Provider: ProviderProtocol {
    
    public let node: Node
    
    private let session: URLSession
    
    public init(node: Node, sessionConfiguration: URLSessionConfiguration) {
        self.node = node
        self.session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
    }
    
    public convenience init(node: Node) {
        self.init(node: node, sessionConfiguration: URLSession.shared.configuration)
    }
    
    deinit {
        self.session.invalidateAndCancel()
    }
    
    /*
     Method that is called from Service to send a request
     */
    func sendRequest(jsonRPCData: Data, completion: @escaping (Error?, Data?) -> Void) {
        
        var request = URLRequest(url: node.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonRPCData
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(error, nil)
                return
            }
            completion(nil, data)
        }
        task.resume()
    }
}
