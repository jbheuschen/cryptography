//: [Previous](@previous)

/*:
 # Example: End-to-End-Encrypted Chat App
 Now where you have learned the theoretics, we'll get practical. How about an end-to-end-encrypted chat app? Let's create one!
 
 Imagine **Bob** and **Alice**, who'd like to securely communicate with each other. However, there is evil **Eve** trying to intercept and modify their letters. Wouldn't it be great if we could help the two of them by giving them an app they can use to chat with one another?
 
 For this we'll use _SwiftUI_ and _CryptoKit_. As we do not have any server infrastructure, we're going to imitate the public key exchange through a helper class. The messages themselves are going to be sent encryptedly via the _NotificationCenter_.
 As to the UI, I'm not going into too much detail. I will, however, pursue a horizontally split interface divided into two independent chat windows (so that the upper one can chat with the lower one).
 
 ## Note
 In order to keep the code more readable, I will define a few typealiases (such as _PublicKey_, _PrivateKey_, or _Identity_). These refer to the _P521_-algorithm's implementation.
 */

//: [Next](@next)
