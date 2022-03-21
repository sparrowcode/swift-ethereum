import Foundation

protocol ProviderProtocol {
    init(node: Node, sessionConfiguration: URLSessionConfiguration)
    init(node: Node)
    func sendRequest()
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
    func sendRequest() {
        
    }
}
