import Foundation

protocol AccountProtocol {
    
    func sign() // signs a data that confirms to signable protocol (make use of generics)
}

public struct Account: AccountProtocol {
    
    public var address: String
    public var publicKey: String
    public var privateKey: String
    
    init(privateKey: String) {
        self.privateKey = privateKey
        self.publicKey = ""
        self.address = ""
        //self.publicKey = privateKey.generatePublicKey()
        //self.address = publicKey.generateAddress()
    }
    
    func sign() {
        
    }
}
