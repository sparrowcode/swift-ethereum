import XCTest
@testable import Ethereum

class AccountManagerTests: XCTestCase {
    
    static let storage = UserDefaultsStorage(password: "password")
    
    let accountManager = AccountManager(storage: storage)
    
    func testCreateAccount() throws {
        let _ = try accountManager.createAccount()
    }
    
    func testImportAccount() throws {
        let privateKey = "95310e470942b7429f39243bbad4a0aa134eecb7d1e029a3b778b18ffa38259a"
        
        let _ = try accountManager.importAccount(privateKey: privateKey)
    }
    
    func testRemoveAccount() throws {
        
        let privateKey = "95310e470942b7429f39243bbad4a0aa134eecb7d1e029a3b778b18ffa38259a"
        
        let account = try accountManager.importAccount(privateKey: privateKey)
        
        try accountManager.removeAccount(account)
        
    }
    
}
