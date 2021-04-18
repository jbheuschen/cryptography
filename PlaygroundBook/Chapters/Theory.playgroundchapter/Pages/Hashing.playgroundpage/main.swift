//:
/*:
 
 [Previous](@previous)
 # Hashing
 First of all, let's begin with hashing. A hash function, as I already explained, processes every input to a unique hash.
 
 ## Crypto Framework
 
 Let's begin by importing the CryptoKit framework.
 
 */

import CryptoKit
import Foundation

/*:
 
 The Crypto framework includes quite a few hashing algorithms, including:
 - SHA-512 (= 512-bit SHA-2-algorithm)
 - SHA-384 (= 384-bit SHA-2-algorithm)
 - SHA-256 (= 256-bit SHA-2-algorithm)
 - SHA-1
 - MD5
 The last two of them are considered insecure and should not be used anymore.
 All these algorithms can essentially be used in the same way, we'll just stick with *SHA-512* for now.
 
 */

func hash(_ string: String) -> SHA512Digest {
    SHA512.hash(data: string.data(using: .utf8)!)
}

/*:
 As you might have noticed, this function returns a *SHA512Digest* object instead of a *String*. We can, however, convert the hash into a textual representation like this:
 */

func stringify(_ data: SHA512Digest) -> String {
    data.compactMap { String(format: "%02x", $0) }.joined()
}

/*:
 
 ### Hashing a file
 
 Hashing a file is essentially the same as we can just pass the file's contents to above-explained function.
 
 */

func hash(file path: String) -> SHA512Digest {
    SHA512.hash(data: FileManager.default.contents(atPath: path)!)
}

/*:
 
 #### Checksums
 
 Checksums are a very important tools helping us to verify a file's integrity, for instance, after downloading it from the internet. Checksums' algorithms usually heavily rely on traditional hashing algorithms.
 
 ### Try it
 Enter a string you want to hash using the *SHA-512* algorithm. Then click run to see the result.
 */

let s = /*#-editable-code A String to Hash*/""/*#-end-editable-code*/

print(stringify(hash(s)))

/*:
 ### Example
 Using the live view to your right, you can try out an interactive tool for hashes. Tip: using the folder icon, you can try file-hashing, too!
 */

import SwiftUI
import UniformTypeIdentifiers
import PlaygroundSupport

extension String {
    
    func sha256() -> String {
        SHA256.hash(data: self.data(using: .utf8)!).compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func sha512() -> String {
        SHA512.hash(data: self.data(using: .utf8)!).compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func sha384() -> String {
        SHA384.hash(data: self.data(using: .utf8)!).compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func sha1() -> String {
        Insecure.SHA1.hash(data: self.data(using: .utf8)!).compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func md5() -> String {
        Insecure.MD5.hash(data: self.data(using: .utf8)!).compactMap { String(format: "%02x", $0) }.joined()
    }
    
}

struct Example : View {
    
    @State var string: String = ""
    @State var file: String?
    @State var isImporting: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("String to hash", text: $string)
                    .padding(.vertical)
                VStack {
                    HStack {
                        Text("SHA-512")
                            .bold()
                        Spacer()
                        Text(string.sha512())
                            .italic()
                            .frame(maxWidth: 250)
                    }.padding(.vertical)
                    HStack {
                        Text("SHA-384")
                            .bold()
                        Spacer()
                        Text(string.sha384())
                            .italic()
                            .frame(maxWidth: 250)
                    }.padding(.vertical)
                    HStack {
                        Text("SHA-256")
                            .bold()
                        Spacer()
                        Text(string.sha256())
                            .italic()
                            .frame(maxWidth: 250)
                    }.padding(.vertical)
                    HStack {
                        Text("SHA-1")
                            .bold()
                        Spacer()
                        Text(string.sha1())
                            .italic()
                            .frame(maxWidth: 250)
                    }.padding(.vertical)
                    HStack {
                        Text("MD5")
                            .bold()
                        Spacer()
                        Text(string.md5())
                            .italic()
                            .frame(maxWidth: 250)
                    }.padding(.vertical)
                }
                Spacer()
            }
            .padding()
            .navigationBarTitle("Hashing")
            .navigationBarItems(trailing: Button(action: {
                self.isImporting = true
            }, label: {
                Image(systemName: "folder")
            })
            .sheet(item: $file) { file in
                NavigationView {
                    Text(file)
                        .navigationBarTitle("File Hash", displayMode: .inline)
                        .padding()
                }
            })
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.text, .image, .archive, .application, .audio]) {
                switch $0 {
                case .success(let url):
                    CFURLStartAccessingSecurityScopedResource(url as CFURL)
                    defer {
                        CFURLStopAccessingSecurityScopedResource(url as CFURL)
                    }
                    guard let data = try? Data(contentsOf: url) else { return }
                    self.file = SHA512.hash(data: data).compactMap { String(format: "%02x", $0) }.joined()
                case .failure(_):
                    break
                }
            }        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

//#-hidden-code
extension String : Identifiable {
    
    public var id: Int {
        self.hash
    }
    
}

extension Data : Identifiable {
    
    public var id: Int {
        self.hashValue
    }
    
}
//#-end-hidden-code



/*:
 ### Conclusion
 
 As you can see, every string, even an empty one, produces its own unique hash. Modifying the string ever so slightly usually results in a totally different hash being generated. The same string, however, will always produce the same hash.
 
 Long story short, you should keep the following in mind:
 - Hashing is a one-way process. Secure hashing-algorithms can practically not be reversed.
 - A hash is unique to the original input data.
 - A hashing algorithm always produces a hash of the same lenght (e.g., SHA-512 => 512 bits).
 
 Hashes are often used when generating a symmetric key from a variable input source. Moreover, hashes should be used when storing passwords.
 */

//: [Next](@next)
