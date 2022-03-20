import Foundation

class AccountManager {
    
    private let storage: StorageProtocol
    
    public init(storage: StorageProtocol) {
        self.storage = storage
    }
    
    static func createAccount() -> Account {
        return Account()
    }
    
    static func importAccount(privateKey: String) -> Account {
        // create, return and store account from private key
        return Account()
    }
    
    static func importAccount(mnemonicPhrase: String) -> Account {
        // create, return and store account from mnemonic phrase
        return Account()
    }
    
    static func removeAccount(_ account: Account) {
        
    }
}

