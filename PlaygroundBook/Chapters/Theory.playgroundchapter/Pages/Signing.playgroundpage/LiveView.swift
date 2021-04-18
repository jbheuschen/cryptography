//: [Previous](@previous)

import CryptoKit
import Foundation

/*:
 # Signing
 
 Let's consider the next thing: Signing. Signing is very important today, even though we often don't even think of it. Imagine your iPad without (Code-)Signing working correctly - it probably wouldn't be of much more use than a block of selden metals to you. Knowing how important signing is, we'll take a look at how it actually works.
 
 ## The Importance of Signing
 
 - Integrety of Data: An attacker trying to modify signed data will not succeed as the signature verification will fail (unless the sender's keys have been compromised, too).
 - Non-Repudiation: Given that signing data is somewhat analogue to physically signing something, that is that assuming the sender's keys have not been compromised, only he can create the unique signature with which the data will have been signed, it can also be used to verify from whom, or prove from where data originated.
 - Message authentication: Through a message's signature, the recepient is assured that the message originates from whom it claims to be.
 
 ## The Theory
 
 In theory, the signature creation process is fairly simple:
 
 - Each party has a keypair (which are usually different than those used for encryption, but principally the same as explained for asymmetric encryption).
 - The data to be signed is fed into a hashing algorithm which produces a unique hash for it.
 - The hash is then, together with the signature key, fed into a signature algorithm thus creating the actual signature.
 - The signature is appended to the actual message (which can either after or before being signed be encrypted, too.).
 
 The recipient can now verify the signature in the following way:
 
 - The signature as well as the verification key (i.e., the sender's public key) are fed into a verification algorithm which produces a hash.
 - Now the recipient hashes the actual data as well and compares this hash to the one produced by the verification algorithm. He can thereby decide whether or not the signature is valid.
 
 **It's important to note that once signed, the signer cannot repudiate having signed the data. It will always be proveable by following above steps. There are, however, ways of digitally "revoking" a signature (e.g., in the case of a compromised private key) that involve the reliance on third parties.**
 
 ## In Practice
 
 CryptoKit supports the same algorithms as for asymmetric encryption. At this point, I'm going to use *Curve25519*.
 First of all, we are going to create our keypair.
 */

typealias PrivateKey = Curve25519.Signing.PrivateKey
typealias PublicKey = Curve25519.Signing.PublicKey
typealias Keypair = (PrivateKey, PublicKey)

func generateKeys() -> Keypair {
    let pk = PrivateKey()
    return (pk, pk.publicKey)
}

/*:
 Signing data at this point is extremely straight-forward:
 */

func sign(data: Data, using key: PrivateKey) throws -> Data {
    try key.signature(for: data)
}

/*:
 And so is verifying the signature, too:
 */

func verify(signature: Data, forData data: Data, withKey key: PublicKey) -> Bool {
    key.isValidSignature(signature, for: data)
}

/*:
 As you can see, everything that seems kind of complicated in the theoretic section is taken over for us by CryptoKit. Isn't that wonderful?
 
 # Try it
 Inside the live view, you can enter a text and generate a signature for it. Use the reload button in the top-right corner to regenerate the underlying keypair. Once you begin entering a text, a second text field will appear. Use this text field to modify your entered text which will the app will then try to verify using the old signature. If signing works, verification will fail unless you keep the text unchanged.
 */

import SwiftUI
import PlaygroundSupport

struct Example : View {
    
    @State var text: String = ""
    @State var text2: String = ""
    @State private var keys: Keypair = generateKeys()
    private var signature: Data? {
        try? sign(data: self.text.data(using: .utf8)!, using: self.keys.0)
    }
    private var verification: Bool {
        guard let signature = self.signature else { return false }
        return verify(signature: signature, forData: self.text.data(using: .utf8)!, withKey: self.keys.1)
    }
    private var verification2: Bool {
        guard let signature = self.signature else { return false }
        return verify(signature: signature, forData: self.text2.data(using: .utf8)!, withKey: self.keys.1)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Text to sign", text: $text)
                    .onChange(of: text, perform: { _ in
                        self.text2 = self.text
                    })
                VStack {
                    HStack {
                        Text("Signature")
                            .bold()
                        Spacer()
                        Text(self.signature?.base64EncodedString() ?? "Error")
                            .italic()
                    }
                    .padding(.bottom)
                    HStack {
                        Text("Verification")
                            .bold()
                        Spacer()
                        Text(self.verification ? "Succeeded" : "Failed")
                            .italic()
                    }
                }
                Text("Now, modify above-entered text below and the verification should fail.")
                    .padding(.vertical)
                if !text2.isEmpty {
                    TextField("", text: $text2)
                        .foregroundColor(self.verification2 ? .green : .red)
                    HStack {
                        Text("Verification 2")
                            .bold()
                        Spacer()
                        Text(self.verification2 ? "Succeeded" : "Failed")
                            .italic()
                        .foregroundColor(self.verification2 ? .green : .red)
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Signing")
            .navigationBarItems(trailing: Button(action: {
                self.keys = generateKeys()
            }, label: {
                Image(systemName: "arrow.clockwise")
            }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

PlaygroundPage.current.setLiveView(Example())
//: [Next](@next)
