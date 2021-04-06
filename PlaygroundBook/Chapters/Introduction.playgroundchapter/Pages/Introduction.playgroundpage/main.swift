//:
/*:
 # Bonjour!
 Welcome to my submission for this year's Swift Student Challenge! This time, it's all about Cryptology.
 
 # What is Cryptology?
 To begin with, Cryptology is often defined as "the practice and study of techniques for secure communication in the presence of third parties". This means that when talking about Cryptography in a programatic sense, our intention often is to protect private messages or sensitive information from being read by unauthorized third parties.
 
 # What will this submission be about?
 Now, I know, this all is very abstract and not really swift-related. I therefore want to shortly explain my intention behind creating this playground: First of all, I want to give a short introduction as to what Cryptology is and what possiblities, mechanisms, algorithms, and so on we generally have. At this point I'll try not to go too deep into the mathematic background as I this playground is focussed on Swift - I will nevertheless try to give a short and easy-to-understand insight onto what happens behind the scenes.
 Second of all, I want to demonstrate what tools Swift gives us developers to work with Cryptology. This will include not only Apple's Security and Swift's Crypto framework but also some self-written code. In order to keep everything easily understandable I'll do this by the example of an end-to-end encrypted chat application. Moreover, I'll try to give as many interactive examples as possible so that you can test out everything youself at any time.
 Lastly, and probably most importantly, I want to explore what else we can do with these technologies and what might be possible in the future.
 
 # Table of Contents
 To make it official, here's how I'll structure my submission. In order to keep things clear, I will need to use some hidden files without explaining them. I will however put them in the Resources folder too so that you can read through them if you'd like to.
 
 - Introduction
 - Cryptology for Dummies
 - Cryptology and Swift
 - The Security Framework
 - The Crypto Framework
 - The iOS Keychain (theoretically)
 - Third-Party Frameworks
 - ...
 
 # Our Usecase
 Wouldn't it be great if we had a way to securely communicate with our friends? Well, there are some. But actually, we can make one ourselves, too.
 
 # Good to Know
 
 - I tested this playground for it's functionality on my MacBook Pro (M1) and iMac, both running macOS 11.2.3 and Xcode 12.4, as well as my 4th-gen iPad Pro running iPadOS 14.4.2. It should therefore run on all devices required by the Submission Guidelines.
 - Techniques used by this playground can be quite processing-intensive, and for some reason Swift Playground sometimes crashes processor-intensive code when using the less-performant "Show Results"-mode. I therefore disabled said mode using the Pages' Manifest.plist file; should a page, however, crash anyways, it would be wonderful of you to check if that mode got somehow enabled.
 
 # Credits
 
 I did not use any third party libraries. During research for my explanatory pages, I used the following sources:
 
 - https://en.wikipedia.org/wiki/Cryptography
 - https://archive.org/details/handbookofapplie0000mene/page/n9/mode/2up
 
 ## Frameworks
 
 Throughout this playground, I use the following Swift frameworks:
 
 - Foundation
 - SwiftUI
 - UIKit
 - CryptoKit
 - CommonCrypto
 - Security
 - Combine
 - PlaygroundSupport
 
[Next](@next)
 */
