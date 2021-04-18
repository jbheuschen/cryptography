//:
/*:
 # Bonjour!
 Welcome to my submission for this year's Swift Student Challenge! This time, it's all about my enthusiasm for Cryptography.
 
 # What is Cryptology?
 To begin with, Cryptology (a.k.a. Cryptography) is usually defined as "the practice and study of techniques for secure communication in the presence of third parties". This means that when talking about Cryptography in a programatic sense, our intention often is to protect private or sensitive information from being read by unauthorized third parties.
 
 # What will this submission be about?
 
 I am aware that parts of this might be quite theoretical, given that Cryptography is such a complex topic. I nevertheless want to explain shortly the techniques we're using as well as give an overview over what Swift offers us developers. That is, I will not only explain the differences between the _Crypto_, _Security_, and _CommonCrypto_ frameworks, as well as their respective advantages or disadvantages, but also give practical examples for Cryptographic operations we can perform. In order to really get practical, I further implemented an end-to-end-encrypted chat application by the example of which I'll explain how straight-forward but powerful it actually is to use Cryptography in your Swift code. Finally, I wrote a short exercise by which you can test your practical knowledge on this topic.
 
 # Table of Contents
 To make it official, here's how I structured my submission. In order to keep things clear, I used some hidden code without explaining it. I will however put it in the user module's _SharedCode_ file, too, so that you can read through it if you'd like to.
 
 - [Introduction](Introduction/Introduction.playgroundpage)
 - [Theory: Cryptology for Dummies](Theory/CfD.playgroundpage)
 - [Cryptology and Swift](Theory/CaS.playgroundpage)
 - [Hashing](Theory/Hashing.playgroundpage)
 - [Signing](Theory/Signing.playgroundpage)
 - [Symmetric Encryption](Theory/Symmetric.playgroundpage)
 - [Asymmetric Encryption](Theory/Asymmetric.playgroundpage)
 - [Cryptography in Practice: End-to-end-encrypted Chat Application](Practice/IntroChat.playgroundpage)
     - [The Key Exchange](Practice/KeyExchange.playgroundpage)
     - [Implementing the end-to-end-encryption](Practice/E2EImplementation.playgroundpage)
     - [The UI](Practice/UI.playgroundpage)
 - [Exercise](Practice/Exercise.playgroundpage)
 
 **Note: If you already are a pro, you don't have to read through the entire theory. Just try the examples and go on ;)**
 The final product can be found on [this](Practice/UI.playgroundpage) page.
 
 # Good to Know
 
 I tested this playground for it's functionality on my MacBook Pro (M1) and iMac, both running macOS 11.2.3 and Xcode 12.4, as well as my 4th-gen iPad Pro running iPadOS 14.4.2. It should therefore run on all devices required by the Submission Guidelines.
 
 # Credits
 
 I did not use any third party libraries. During research for my explanatory pages, I used the following sources:
 
 - https://en.wikipedia.org/wiki/Cryptography
 - https://archive.org/details/handbookofapplie0000mene/page/n9/mode/2up
 
 Image sources:
 
 - https://www.electronicdesign.com/technologies/embedded-revolution/article/21132412/maxim-integrated-cryptographic-implementations-hardware-vs-software
 - https://www.livescience.com/38936-mathematics.html
 
 ## Frameworks
 
 Throughout this playground, I use the following Swift frameworks:
 
 - Foundation
 - SwiftUI
 - UIKit
 - CryptoKit
 - CommonCrypto
 - Security
 - Combine
 - UniformTypeIdentifiers
 - PlaygroundSupport
 
[Next](@next)
 */
