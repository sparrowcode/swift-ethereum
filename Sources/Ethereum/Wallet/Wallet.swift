//
//  Wallet.swift
//  
//
//  Created by Ertem Biyik on 18.03.2022.
//

import Foundation

public class Wallet {
    
    public static func importAccount(privateKey: String) -> Account {
        // create, return and store account from private key
        return Account()
    }
    
    public static func importAccount(mnemonicPhrase: String) -> Account {
        // create, return and store account from mnemonic phrase
        return Account()
    }
    
    public static func createAccount() -> Account {
        return Account()
    }
}
