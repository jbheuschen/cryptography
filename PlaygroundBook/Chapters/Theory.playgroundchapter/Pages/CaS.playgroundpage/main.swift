//: [Previous](@previous)

/*:
 # Cryptology and Swift
 
 Swift essentially offers us three first-party frameworks to work with:
 
 ## CryptoKit / Crypto
 Cryptology in Swift has a long, albeit sometimes complicated, history. Nowadays, Apple gives us through _CryptoKit_ a handy and powerful framework to work with these kinds of things. On third party platforms, Swift offers "Crypto", an open-source implementation of _CryptoKit_ that is based on _BoringSSL_, thereby creating API-compatibility.
 
 ## CommonCrypto
 Prior to CryptoKit, CommonCrypto was an ubiquitous tool. CommonCrypto, however, is a library written in C and thus sometimes uncomfortable to use. For this reason, there are many third-party wrappers around CommonCrypto intending to make CC "swiftier" - something that has now been accomplished first-partily through Crypto(Kit). Today, CommonCrypto is often still used directly when the usage of algorithms not supported by CryptoKit is required. For instance:
 
 */
 
import Foundation
import CommonCrypto

func createAESKey(withPassword data: Data, usingSalt salt: Data) -> Data? {
    
    var status: Int32 = 0
    var derivedBytes = [UInt8](repeating: 0, count: kCCKeySizeAES256)
    
    data.withUnsafeBytes { rawBufferPointer in
        let dataRawBytes = rawBufferPointer.baseAddress!
        let dataBytes = dataRawBytes.assumingMemoryBound(to: Int8.self)
        
        salt.withUnsafeBytes { rawBufferPointer in
            let saltRawBytes = rawBufferPointer.baseAddress!
            let saltBytes = saltRawBytes.assumingMemoryBound(to: UInt8.self)
            status = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2), dataBytes, data.count, saltBytes, salt.count, CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1), 10000, &derivedBytes, kCCKeySizeAES256)
        }
    }
    
    guard status == 0 else {
        return nil
    }
    
    return Data(bytes: &derivedBytes, count: kCCKeySizeAES256)
}

/*:
 As you can see, this is not really a "swifty" way of dealing with cryptography. _CommonCrypto_ often requires us to deal with unsafe pointers, manually release objects in defer-clauses, and so on. In my opinion, it's therefore in our interest to use _CryptoKit_ whenever possible.
 
 ## Security
 While the _Security_ framework has very broad use cases, we can also utilize it for our "cryptographic studies". For instance, we can use the system keychain to securely store our keys! Further, the _Security_ framework allows us to securely generate random numbers (and keys) or perform certain cryptographic functions using a device's secure enclave coprocessor. For instance:
 */

import Security

func generateAndStoreRSAKey() throws -> SecKey {
    let keyTag = "de.fheuschen.wwdc21.ssc.Cryptography".data(using: .utf8)!
    let attributes: [String: Any] =
        [
            kSecAttrKeyType as String : kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String : 2048,
            kSecPrivateKeyAttrs as String : [kSecAttrIsPermanent as String : true, kSecAttrApplicationTag as String : keyTag]
        ]
    var error: Unmanaged<CFError>?
    guard let pKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
        throw error!.takeRetainedValue()
    }
    return pKey
}

/*:
 The _Security_ framework allows us to generate random bytes like this:
 */

func randomBytes(length: Int) -> Data {
    var random = Data(count: length)
    var mutableBytes: UnsafeMutableRawPointer!
    
    random.withUnsafeMutableBytes { bufferPointer in
        mutableBytes = bufferPointer.baseAddress!
    }
    
    guard SecRandomCopyBytes(kSecRandomDefault, length, mutableBytes) == 0 else {
        fatalError("Unable to get random bytes.")
    }
    return random
}

//: [Next](@next)
