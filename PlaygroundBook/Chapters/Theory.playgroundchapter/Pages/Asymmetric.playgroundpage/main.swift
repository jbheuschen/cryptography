//: [Previous](@previous)

import Foundation
import CryptoKit

extension Data {
    
    func asString() -> String {
        self.compactMap { String(format: "%02x", $0) }.joined()
    }
    
}


/*:
 
 # Public-Key-based Encryption and Decryption
 Currently, Apple's CryptoKit framework supports the following asymmetric algorithms:
 - P521
 - P384
 - P256
 - Curve25519
 I'll use P521 at this point.
 ## Key Generation
 We'll generate a keypair consisting of a private key and the corresponding public key by simply initializing an instance of *P521.KeyAgreement.PrivateKey*.
 */

typealias PublicKey = P521.KeyAgreement.PublicKey
typealias PrivateKey = P521.KeyAgreement.PrivateKey
typealias Keypair = (publicKey: PublicKey, privateKey: PrivateKey)

let protocolSalt = "SALT".data(using: .utf8)!

func generateKeys() -> Keypair {
    let privateKey = P521.KeyAgreement.PrivateKey()
    return (privateKey.publicKey, privateKey)
}

/*:
 In a practical example, we would now be publishing our public key. To keep things simple at this point, we'll simply use two local keypairs.
 ## Encrypting
 When it comes to encrypting a message, we first have to get a symmetric key from our public key using the key agreement with the recipient. Yes, that's right - asymmetric encryption indirectly utilizes symmetric encryption. But how can we do that? Well...
 */

func symmetricKey(forPublicKey publicKey: PublicKey, andMyPrivateKey privateKey: PrivateKey) -> SymmetricKey {
    try! privateKey.sharedSecretFromKeyAgreement(with: publicKey).hkdfDerivedSymmetricKey(using: SHA256.self, salt: protocolSalt, sharedInfo: Data(), outputByteCount: 32)
}

/*:
 Having done that, we can move on to the encryption itself which will be pretty much the same as on the previous page.
 */

func encryptMessage(message data: Data, using symmetricKey: SymmetricKey) -> Data {
    try! ChaChaPoly.seal(data, using: symmetricKey).combined
}

func encryptMessage(message data: Data, myPrivateKey privateKey: PrivateKey, recipientPublicKey publicKey: PublicKey) -> Data {
    encryptMessage(message: data, using: symmetricKey(forPublicKey: publicKey, andMyPrivateKey: privateKey))
}

/*:
 ## Decryption
 Decryption is pretty straight-forward at this point. We'll just retrieve a symmetric key again and decrypt using that one.
 */

func decryptMessage(encryptedMessage data: Data, using symmetricKey: SymmetricKey) -> Data {
    try! ChaChaPoly.open(ChaChaPoly.SealedBox(combined: data), using: symmetricKey)
}

func decryptMessage(encryptedMessage data: Data, myPrivateKey privateKey: PrivateKey, senderPublicKey publicKey: PublicKey) -> Data {
    decryptMessage(encryptedMessage: data, using: symmetricKey(forPublicKey: publicKey, andMyPrivateKey: privateKey))
}

/*:
 ---
 ## Try it
 We'll use two seperate keypairs in order to simulate end-to-end encryption. Feel free to edit and play with the code!
 */

//#-editable-code

let me = generateKeys(), other = generateKeys()

let message = "Lorem ipsum dolor sit amet."

let encrypted = encryptMessage(message: message.data(using: .utf8)!, myPrivateKey: me.privateKey, recipientPublicKey: other.publicKey)

print(encrypted.asString())

//: **At this point, we are changing perspective and decrypting as "the other".**

let decrypted = decryptMessage(encryptedMessage: encrypted, myPrivateKey: other.privateKey, senderPublicKey: me.publicKey)

print(String(data: decrypted, encoding: .utf8)!)

//#-end-editable-code
//: [Next](@next)
