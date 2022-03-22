import Foundation

public enum Storage {
    
    case userDefaults
    case keychain
    case icloud
}

/**
 Ethereum: StorageProtocol that describes Storage object
 */
public protocol StorageProtocol {
    
    func storePrivateKey(_ key: String)
    func getPrivateKey(for address: String)
    func removePrivateKey(for address: String)
}
