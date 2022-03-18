//
//  Provider.swift
//  
//
//  Created by Ertem Biyik on 18.03.2022.
//

import Foundation

open class Provider {
    
    public let url: URL
    
    private let session: URLSession
    
    required public init(url: URL, sessionConfiguration: URLSessionConfiguration) {
        self.url = url
        self.session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
    }
    
    required public convenience init(url: URL) {
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
