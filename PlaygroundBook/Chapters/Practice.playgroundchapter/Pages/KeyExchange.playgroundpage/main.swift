//: [Previous](@previous)

import Foundation
import CryptoKit

/*:
 # The Key Exchange
 An important part when implementing end-to-end encryption is the exchange of public keys. As we're not writing a "real" chat app communicating between multiple devices, we can implement this purely locally.
 
 Participant's public keys are, mapped to their identity, stored in a dictionary. _Participant_ instances (see following pages) will upon initialization generate their keypair and register it with this "identity database". When sending and receiving chat messages, this class will act as a trusted keystore and be used by the clients to retrieve the other's public key.
 */

public typealias Identity = String
public typealias PublicKey = P521.KeyAgreement.PublicKey
public typealias PrivateKey = P521.KeyAgreement.PrivateKey
public typealias Keypair = (publicKey: PublicKey, privateKey: PrivateKey)

public class KeyExchange {
    
    private var parties: [Identity : PublicKey] = [:]
    
    public func registerIdentity(_ identity: Identity, withPublicKey publicKey: PublicKey) {
        self.parties[identity] = publicKey
    }
    
    public func unregisterIdentity(_ identity: Identity) {
        self.parties[identity] = nil
    }
    
    public func fetchPublicKeyFor(identity: Identity) -> PublicKey? {
        self.parties[identity]
    }
    
}

//: [Next](@next)
