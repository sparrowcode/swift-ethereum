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
    
    func storePrivateKey(_ privateKey: String) throws
    func getPrivateKey(for address: String) throws -> String
    func removePrivateKey(for address: String) throws
}

public enum StorageError: Error {
    case noValueForKey(String)
}
