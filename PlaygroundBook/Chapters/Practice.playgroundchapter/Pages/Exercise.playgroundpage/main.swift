/*:
 # Exercise
 If you read the foregoing pages carefully, you should be able to finish the following implementation :). Feel free to look up things you don't remember correctly (tip: you can find my solution at the end of this page...). Once you've finished your implementation, you can run the page and watch the console output...
 */

import Foundation
import CryptoKit

typealias PublicKey = P384.KeyAgreement.PublicKey
typealias PrivateKey = P384.KeyAgreement.PrivateKey
typealias Keypair = (publicKey: PublicKey, privateKey: PrivateKey)

protocol ExerciseA {
    
    func generateKeypair() -> Keypair
    func encrypt(string: String, using symmetricKey: SymmetricKey) -> Data
    func decrypt(data: Data, using symmetricKey: SymmetricKey) -> String
    
}

extension ExerciseA {
    
    func symmetricKey(forPublicKey pubKey: PublicKey, andPrivateKey privKey: PrivateKey) -> SymmetricKey {
        try! privKey.sharedSecretFromKeyAgreement(with: pubKey).hkdfDerivedSymmetricKey(using: SHA256.self, salt: "".data(using: .utf8)!, sharedInfo: Data(), outputByteCount: 32)
    }
    
}

//#-editable-code
class YourImplementation : ExerciseA {
    
    func encrypt(string: String, using symmetricKey: SymmetricKey) -> Data {
        <#code#>
    }
    
    func decrypt(data: Data, using symmetricKey: SymmetricKey) -> String {
        <#code#>
    }
    
    func generateKeypair() -> Keypair {
        <#code#>
    }
    
}

//#-end-editable-code

/*:
 # Trying your solution
 An error will be thrown if your solution does not work as expected.
 */

typealias Implementation = Solution

let impl = Implementation()
let kPA = impl.generateKeypair(), kPB = impl.generateKeypair()

let str = "Swift Student Challenge 2021"

let enc = impl.encrypt(string: str, using: impl.symmetricKey(forPublicKey: kPB.publicKey, andPrivateKey: kPA.privateKey))

guard impl.decrypt(data: enc, using: impl.symmetricKey(forPublicKey: kPA.publicKey, andPrivateKey: kPB.privateKey)) == str else {
    fatalError("Decryption failed.")
}

print("Decryption succeeded.")

/*:
 # Solution
 Below, you can find my solution.
 */

class Solution : ExerciseA {
    
    func encrypt(string: String, using symmetricKey: SymmetricKey) -> Data {
        try! ChaChaPoly.seal(string.data(using: .utf8)!, using: symmetricKey).combined
    }
    
    func decrypt(data: Data, using symmetricKey: SymmetricKey) -> String {
        String(data: try! ChaChaPoly.open(ChaChaPoly.SealedBox(combined: data), using: symmetricKey), encoding: .utf8)!
    }
    
    func generateKeypair() -> Keypair {
        let pK = PrivateKey()
        return (pK.publicKey, pK)
    }
    
}

/*:
 # The End
 
 You've reached the end of my playground. I hope I was able to teach you something (you didn't know yet) about Cryptography. Moreover, I hope I was able to let you take part in my enthusiasm for computer science in general, and Swift in particular! Thanks for taking time to read through this playground :)
 */
