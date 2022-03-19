//
//  Service.swift
//  
//
//  Created by Ertem Biyik on 18.03.2022.
//

import Foundation

public final class EthereumService {
    
    public static var provider: Provider = Provider(url: URL(string: "")!)
    
    public static var wallet: Wallet = Wallet()
    
    public static var storage: Storage = Storage()
    
    public enum Eth {
        
        public static func protocolVersion() {
            
        }
        
        public static func syncing() {
            
        }
        
        public static func coinbase() {
            
        }
        
        public static func mining() {
            
        }
        
        public static func hashrate() {
            
        }
        
        public static func gasPrice() {
            
        }
        
        public static func accounts() {
            
        }
        
        public static func blockNumber() {
            
        }
        
        public static func getBalance() {
            
        }
        
        public static func getStorageAt() {
            
        }
        
        public static func getBlockTransactionCountByHash() {
            
        }
        
        public static func getBlockTransactionCountByNumber() {
            
        }
        
        public static func sign() {
            
        }
        
        public static func sendTransaction() {
            
        }
        
        public static func sendRawTransaction() {
            
        }
        
        public static func call() {
            
        }
        
        public static func estimateGas() {
            
        }
        
        public static func getBlockByHash() {
            
        }
        
        public static func getBlockByNumber() {
            
        }
        
        public static func getTransactionByHash() {
            
        }
        
        public static func getTransactionByBlockHashAndIndex() {
            
        }
        
        public static func getTransactionByBlockNumberAndIndex() {
            
        }
        
        public static func getTransactionReceipt() {
            
        }
        
        public static func getUncleByBlockHashAndIndex() {
            
        }
        
        public static func getUncleByBlockNumberAndIndex() {
            
        }
        
        public static func getCompilers() {
            
        }
        
        public static func compileLLL() {
            
        }
        
        public static func compileSolidity() {
            
        }
        
        public static func compileSerpent() {
            
        }
        
        public static func newFilter() {
            
        }
        
        public static func newBlockFilter() {
            
        }
        
        public static func newPendingTransactionFilter() {
            
        }
        
        public static func uninstallFilter() {
            
        }
        
        public static func getFilterChanges() {
            
        }
        
        public static func getLogs() {
            
        }
        
        public static func getWork() {
            
        }
        
        public static func submitWork() {
            
        }
        
        public static func submitHashrate() {
            
        }
        
    }
    
    public enum Net {
        
        public static func version() {
            
        }
        
        public static func listening() {
            
        }
        
        public static func peerCount() {
            
        }
        
    }
    
    public enum Web3 {
        
        public static func clientVersion() {
            
        }
        
        public static func sha3() {
            
        }
    }
}
