import Foundation

struct UserDefaultsStorage: StorageProtocol {
    
    func storePrivateKey(_ privateKey: String, password: String) throws {
        
        // MARK: - Check for length of password to choose which aes (128/256) to use, randomly create initial vector
        
        let publicKey = try AccountManager.getPublicKey(from: privateKey)
        let address = try AccountManager.getEthereumAddress(from: publicKey)
        
        let aes = try AES(password: password,
                               iv: "abcdefghijklmnop")
        
        let aesEncryptedPrivateKey = try aes.encrypt(string: privateKey)
        
        UserDefaults.standard.set(aesEncryptedPrivateKey, forKey: address)
    }
    
    func getPrivateKey(for address: String, password: String) throws -> String {
        
        let aes = try AES(password: password,
                               iv: "abcdefghijklmnop")
        
        guard let aesEncryptedPrivateKey = UserDefaults.standard.data(forKey: address) else {
            throw StorageError.noValueForKey(address)
        }
        
        let decryptedPrivateKey = try aes.decrypt(data: aesEncryptedPrivateKey)
        
        return decryptedPrivateKey
    }
    
    func removePrivateKey(for address: String) throws {
        UserDefaults.standard.set(nil, forKey: address)
    }
}
