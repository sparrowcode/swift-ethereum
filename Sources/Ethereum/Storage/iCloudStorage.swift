import Foundation

enum iCloudStorage: StorageProtocol {
    
    func storePrivateKey(_ privateKey: String, password: String) throws {
        
        
    }
    
    func getPrivateKey(for address: String, password: String) throws -> String {
        return ""
    }
    
    func removePrivateKey(for address: String) throws {
        
    }
}
