import Foundation

public struct UserDefaultsStorage: StorageProtocol {
    
    private let aes = AES()
    
    private let password: String
    
    public init(password: String) {
        self.password = password
    }
    
    public func storePrivateKey(_ privateKey: String) throws {
        
        let publicKey = try Utils.KeyUtils.getPublicKey(from: privateKey)
        
        let address = try Utils.KeyUtils.getEthereumAddress(from: publicKey)
        
        let iv = aes.initialVector
        
        let aesEncryptedPrivateKey = try aes.encrypt(privateKey, password: password, iv: iv)
        
        let file = StorageFile(keyData: aesEncryptedPrivateKey, iv: iv)
        
        let encodedFile = try JSONEncoder().encode(file)
        
        UserDefaults.standard.set(encodedFile, forKey: address)
    }
    
    public func getPrivateKey(for address: String) throws -> String {
        
        guard let file = UserDefaults.standard.data(forKey: address) else {
            throw StorageError.noValueForKey(address)
        }
        
        let decodedFile = try JSONDecoder().decode(StorageFile.self, from: file)
        
        let aesEncryptedPrivateKey = decodedFile.keyData
        
        let iv = decodedFile.iv
        
        let decryptedPrivateKey = try aes.decrypt(aesEncryptedPrivateKey, password: password, iv: iv)
        
        return decryptedPrivateKey
    }
    
    public func removePrivateKey(for address: String) throws {
        UserDefaults.standard.set(nil, forKey: address)
    }
}
