import Foundation
import CryptoKit

public struct EH {
    
    public static func encrypt(data: Data, using key: SymmetricKey) throws -> Data {
        try ChaChaPoly.SealedBox(combined: ChaChaPoly.seal(data, using: key).combined).combined
    }

    public static func decrypt(ciphertext data: Data, using key: SymmetricKey) throws -> Data {
        try ChaChaPoly.open(try ChaChaPoly.SealedBox(combined: data), using: key)
    }
    
}
