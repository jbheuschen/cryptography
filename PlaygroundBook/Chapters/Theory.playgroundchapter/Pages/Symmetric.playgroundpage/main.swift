//: [Previous](@previous)

import Foundation
import CryptoKit
import E2E

//#-hidden-code
enum E : Error {
    case generic(String)
}

extension Data {
    
    func asString() -> String {
        self.compactMap { String(format: "%02x", $0) }.joined()
    }
    
}
//#-end-hidden-code

/*:
 # Encrypting and Decrypting Data Symmetrically
 
 ## Creating the Key
 
 The key creation is very straight-forward. This creates a 256-bit symmetric key:
 */

let key = SymmetricKey(size: .bits256)

/*:
 
 ## Encryption
 
 *CryptoKit* offers two algorithms for us to encrypt: *AES-GCM* and *ChaChaPoly*. The latter is often preferred for performance reasons, which is why we'll use it at this point.
 */

func encrypt(data: Data, using key: SymmetricKey) throws -> Data {
    if let encryptedBox = try? ChaChaPoly.seal(data, using: key), let sealedBox = try? ChaChaPoly.SealedBox(combined: encryptedBox.combined) {
        return sealedBox.combined
    } else {
        throw E.generic("Encryption failed.")
    }
}

/*:
 
 ## Decryption
 
 */

func decrypt(ciphertext data: Data, using key: SymmetricKey) throws -> Data {
    if let data = try? ChaChaPoly.open(try ChaChaPoly.SealedBox(combined: data), using: key) {
        return data
    } else {
        throw E.generic("Decryption failed.")
    }
}

/*:
 
 ## Example
 
 Using the live view on your right hand side, you can test the following example. In the upper text field, you can enter a key using which the text you enter in the second text field will be encrypted. You can then click the lock in the top-righthand corner to open the decryption routine. Here you just have to enter the key again and - voilà - the decryption should succeed.
 */

import SwiftUI
import PlaygroundSupport
//#-editable-code
extension String {
    
    func encrypt(using key: SymmetricKey) -> String {
        try! EH.encrypt(data: self.data(using: .utf8)!, using: key).base64EncodedString()
    }
    
    func decrypt(using key: SymmetricKey) -> String? {
        try? String(data: EH.decrypt(ciphertext: Data(base64Encoded: self) ?? self.data(using: .utf8)!, using: key), encoding: .utf8)
    }
    
}
//#-end-editable-code
struct Example : View {
    
    @State var key: String = ""
    @State var string: String = ""
    @State var decryption: Bool = false
    
    var symmetricKey: SymmetricKey {
        SymmetricKey(data: SHA256.hash(data: self.key.data(using: .utf8)!)) // Yet another advantage of using hashes: They're always the same lenght
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    TextField("Key", text: $key)
                    TextField("String", text: $string)
                }
                HStack {
                    Text("Encrypted")
                        .bold()
                    Text(string.encrypt(using: self.symmetricKey))
                        .italic()
                    Button(action: {
                        UIPasteboard.general.string = string.encrypt(using: self.symmetricKey)
                    }, label: {
                        Image(systemName: "doc.on.clipboard")
                    })
                }
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        self.decryption = true
                    }, label: {
                        Image(systemName: "lock.open")
                    })
                }
            }
            .sheet(isPresented: $decryption) {
                DecryptionExample(string: string.encrypt(using: self.symmetricKey))
            }
            .navigationTitle("Symmetric Encryption")
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct DecryptionExample : View {
    
    @State var key: String = ""
    @State var string: String
    
    var symmetricKey: SymmetricKey {
        SymmetricKey(data: SHA256.hash(data: self.key.data(using: .utf8)!)) // Yet another advantage of using hashes: They're always the same lenght
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    TextField("Key", text: $key)
                    TextField("Encrypted String", text: $string)
                }
                HStack {
                    Text("Decrypted")
                        .bold()
                    Text(self.string.decrypt(using: self.symmetricKey) ?? "Decryption failed.")
                        .italic()
                    Button(action: {
                        UIPasteboard.general.string = string.decrypt(using: self.symmetricKey)
                    }, label: {
                        Image(systemName: "doc.on.clipboard")
                    })
                }
                Spacer()
            }
            .navigationBarTitle("Decryption", displayMode: .inline)
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

//: [Next](@next)
