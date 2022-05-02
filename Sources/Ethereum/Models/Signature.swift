import Foundation

public struct Signature {
    
    public var v: Int
    public let r: Data
    public let s: Data
    
    public init(_ signedData: Data) {
        self.v = Int(signedData[64])
        self.r = signedData.subdata(in: 0..<32).removeLeadingZeros
        self.s = signedData.subdata(in: 32..<64).removeLeadingZeros
    }
    
    public init(v: Int, r: Data, s: Data) {
        self.v = v
        self.r = r
        self.s = s
    }
    
    public mutating func calculateV(with chainID: Int?) {
        if v < 37 {
            v += (chainID ?? -1) * 2 + 35
        }
    }
    
}
