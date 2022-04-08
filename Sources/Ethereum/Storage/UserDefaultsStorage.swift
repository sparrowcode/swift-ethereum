import Foundation

enum UserDefaultsStorage: StorageProtocol {
    
    func storePrivateKey(_ privateKey: String) throws {
        
        let publicKey = try AccountManager.getPublicKey(from: privateKey)
        let address = try AccountManager.getEthereumAddress(from: publicKey)
        
        UserDefaults.standard.set(privateKey, forKey: address)
    }
    
    func getPrivateKey(for address: String) throws -> String {
        
        guard let privateKey = UserDefaults.standard.string(forKey: address) else {
            throw StorageError.noValueForKey(address)
        }
        
        return privateKey
    }
    
    func removePrivateKey(for address: String) throws {
        UserDefaults.standard.set(nil, forKey: address)
    }
}
