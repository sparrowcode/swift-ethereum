import Foundation

public struct KeychainStorage: StorageProtocol {
    
    private let aes = AES()
    
    private let password: String
    
    public init(password: String) {
        self.password = password
    }
    
    public func storePrivateKey(_ privateKey: String) throws {
        
    }
    
    public func getPrivateKey(for address: String) throws -> String {
        return ""
    }
    
    public func removePrivateKey(for address: String) throws {
        
    }
}
