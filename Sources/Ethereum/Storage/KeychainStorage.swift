import Foundation

struct KeychainStorage: StorageProtocol {
    
    private let aes = AES()
    
    private let password: String
    
    public init(password: String) {
        self.password = password
    }
    
    func storePrivateKey(_ privateKey: String) throws {
        
    }
    
    func getPrivateKey(for address: String) throws -> String {
        return ""
    }
    
    func removePrivateKey(for address: String) throws {
        
    }
}
