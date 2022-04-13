import Foundation

struct UserDefaultsStorage: StorageProtocol {
    
    private let aes = AES()
    
    private let password: String
    
    public init(password: String) {
        self.password = password
    }
    
    public func storePrivateKey(_ privateKey: String) throws {
        
        let publicKey = try AccountManager.getPublicKey(from: privateKey)
        
        let address = try AccountManager.getEthereumAddress(from: publicKey)
        
        let aesEncryptedPrivateKey = try aes.encrypt(string: privateKey, password: password)
        
        UserDefaults.standard.set(aesEncryptedPrivateKey, forKey: address)
    }
    
    public func getPrivateKey(for address: String) throws -> String {
        
        guard let aesEncryptedPrivateKey = UserDefaults.standard.data(forKey: address) else {
            throw StorageError.noValueForKey(address)
        }
        
        let decryptedPrivateKey = try aes.decrypt(data: aesEncryptedPrivateKey, password: password)
        
        return decryptedPrivateKey
    }
    
    public func removePrivateKey(for address: String) throws {
        UserDefaults.standard.set(nil, forKey: address)
    }
}
