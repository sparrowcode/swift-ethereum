import Foundation

enum KeychainStorage: StorageProtocol {
    
    func storePrivateKey(_ privateKey: String) throws {
        
    }
    
    func getPrivateKey(for address: String) throws -> String {
        return ""
    }
    
    func removePrivateKey(for address: String) throws {
        
    }
}
