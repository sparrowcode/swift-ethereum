import Foundation

protocol AccountProtocol {
    
    func sign<T: Signable>(_ value: T) // signs a data that confirms to signable protocol (make use of generics)
}

protocol Signable {
    
}

public struct Account: AccountProtocol {
    
    public var address: String
    public var publicKey: String
    public var privateKey: String
    
    init(privateKey: String) throws {
        self.privateKey = privateKey
        self.publicKey = try AccountManager.getPublicKey(from: privateKey)
        self.address = try AccountManager.getEthereumAddress(from: publicKey)
    }
    
    func sign<T>(_ value: T) where T : Signable {
        
    }
}
