//: [Previous](@previous)

/*:
 # Cryptology for Dummies
 ![Cryptology for Dummies](cfd.jpg)
 On the foregoing page I already gave a short definition of what Cryptology is. At this point, I'll get a bit more practical by limiting myself to the programmatic aspect of Cryptology - i.e., how can we utilize Cryptology in our projects?
 Well, the answer often is quite simple - most of us are already using it! It's something we often forget but for instance every HTTPS request we make is obviously being encrypted - which already leads us to the first way of utilizing Cryptography: encryption. With encryption comes decryption; hence, we already have our first principle complete.
 
 ## Encryption and Decryption
 Now the principle seems simple - we encrypt data and someone else can decrypt it. But how? Well, there essentially are two ways.
 
 ### Encryption using a symmetric key
 Using a symmetric key, all communicating parties must possess the same key in order to be able to encrypt or decrypt. It is important to mention at this point that messages are being encrypted and decrypt using the exact same key in this scheme.
 
 ### Encryption using a public key
 Using a public-/private-key scheme allows us to keep things a little more secure. We now have a public key, that can only be used to encrypt messages. As the name suggests, this key is usable by everyone. A person must be in possession of the corresponding private key in order to be able to decrypt an encrypted message. For communication to be successful, all parties have to exchange their public keys with one another ("handshake").
 Keys are usually pseudo-randomly generated.
 
 #### Certificates
 
 A public key's origin can be certified through a public key-certificate. A such essentially contains information about the public key itself as well as the key's owner and is itself signed by a trusted Certification Authority's private key. A great example for this are so-called "HTTPS-Certificates". In order for HTTPS to work, web traffic is being encrypted asymmetrically. During the key agreement process, the client usually wants to make sure the keys they're presented with are authentic (see man-in-the-middle attack) - for that purpose, the server presents the client with a certificate signed by a trusted CA.
 
 ## Signing
 Signing something on the other hand is some sort of an analogy to physically signing a letter (just that its way more secure!). In doing so, we have the same public-key-scheme mentioned above: we are now using our private key to create a signature for a message. This signature involves hashing the content of the message itself and can be checked for its authenticity by others using our public key.
 
 ## Hashing
 Hashing is often mistaken to be a sort of encryption. It's not, though - when hashing there is no key whatsoever. Instead, a given message is processed by a so-called hashing function, resulting in a hash. This hash is unique to the original message, i.e., the same message will always produce the same hash. The original message, however, can not be "decrypted" from the hash (at least without brute-forcing). Hashing is often used to securely store user passwords.
 
 ## Conclusion
 There are three aspects of Cryptology I will look at in my submission: Encryption, Signing, and Hashing - all of which are very important in our lives, even though we often don't even notice them taking place.
 
 ## Keep in mind: Mathematic solvability of underlying algorithmic problems
 Everything in Cryptography works through mathematics, specifically mathematic problems. Encryption, for instance, relies on the difficulty to solve certain mathematic problems and the resulting inability of both humans and computers to solve these problems in a reasonable amount of time. Therefore:
 - Theoretically, most cryptographic algorithms are solveable. We have to differentiate between mathematic theory and computer scientific practice, though - because in practice, they currently are not solveable (unless you have milleniums of time to spend on solving them).
 - The processing power of computers, however, evolves relatively quickly. By more powerful machines becoming available, the list of algorithms considered secure thus changes. Another interesting topic to keep in mind is quantum computers. In theory, they can solve many mathematic problems cryptographic algorithms rely on with not problems whatsoever. We'll see what them eventually becoming available in the future will mean for today's cryptographic world.
 
 */

//: [Next](@next)
