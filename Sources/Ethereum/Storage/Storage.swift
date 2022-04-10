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
    
    func storePrivateKey(_ privateKey: String, password: String) throws
    func getPrivateKey(for address: String, password: String) throws -> String
    func removePrivateKey(for address: String) throws
}

enum StorageError: Error {
    case noValueForKey(String)
}
