import Foundation

class AccountManager {
    
    private let storage: StorageProtocol
    
    public init(storage: StorageProtocol) {
        self.storage = storage
    }
    
    static func createAccount() -> Account {
        return Account(privateKey: "")
    }
    
    static func importAccount(privateKey: String) -> Account {
        // create, return and store account from private key
        return Account(privateKey: "")
    }
    
    static func removeAccount(_ account: Account) {
        
    }
}

