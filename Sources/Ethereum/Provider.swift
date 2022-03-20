import Foundation

protocol ProviderProtocol {
    
    init(url: URL, sessionConfiguration: URLSessionConfiguration)
    init(url: URL)
    func sendRequest()
}

public final class Provider: ProviderProtocol {
    
    public let url: URL
    
    private let session: URLSession
    
    public init(url: URL, sessionConfiguration: URLSessionConfiguration) {
        self.url = url
        self.session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
    }
    
    public convenience init(url: URL) {
        self.init(url: url, sessionConfiguration: URLSession.shared.configuration)
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
