import Foundation

struct UserDefaultsStorage: StorageProtocol {
    
    private let aes = AES()
    
    private let password: String
    
    public init(password: String) {
        self.password = password
    }
    
    func storePrivateKey(_ privateKey: String) throws {
        
        let publicKey = try Utils.getPublicKey(from: privateKey)
        
        let address = try Utils.getEthereumAddress(from: publicKey)
        
        let iv = aes.initialVector
        
        let aesEncryptedPrivateKey = try aes.encrypt(string: privateKey, password: password, iv: iv)
        
        let file = StorageFile(keyData: aesEncryptedPrivateKey, iv: iv)
        
        let encodedFile = try JSONEncoder().encode(file)
        
        UserDefaults.standard.set(encodedFile, forKey: address)
    }
    
    func getPrivateKey(for address: String) throws -> String {
        
        guard let file = UserDefaults.standard.data(forKey: address) else {
            throw StorageError.noValueForKey(address)
        }
        
        let decodedFile = try JSONDecoder().decode(StorageFile.self, from: file)
        
        let aesEncryptedPrivateKey = decodedFile.keyData
        
        let iv = decodedFile.iv
        
        let decryptedPrivateKey = try aes.decrypt(data: aesEncryptedPrivateKey, password: password, iv: iv)
        
        return decryptedPrivateKey
    }
    
    func removePrivateKey(for address: String) throws {
        UserDefaults.standard.set(nil, forKey: address)
    }
}
