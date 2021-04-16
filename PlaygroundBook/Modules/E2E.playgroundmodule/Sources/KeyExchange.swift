import Foundation
import CryptoKit
import SwiftUI
import Combine

public typealias Identity = String
public typealias PublicKey = P521.KeyAgreement.PublicKey
public typealias PrivateKey = P521.KeyAgreement.PrivateKey
public typealias Keypair = (publicKey: PublicKey, privateKey: PrivateKey)

public let protocolSalt = "SALT".data(using: .utf8)!

public func generateKeys() -> Keypair {
    let privateKey = PrivateKey()
    return (privateKey.publicKey, privateKey)
}

public func symmetricKey(forPublicKey publicKey: PublicKey, andMyPrivateKey privateKey: PrivateKey) -> SymmetricKey {
    try! privateKey.sharedSecretFromKeyAgreement(with: publicKey).hkdfDerivedSymmetricKey(using: SHA256.self, salt: protocolSalt, sharedInfo: Data(), outputByteCount: 32)
}

public func encryptMessage(message data: Data, using symmetricKey: SymmetricKey) -> Data {
    try! ChaChaPoly.seal(data, using: symmetricKey).combined
}

public func encryptMessage(message data: Data, myPrivateKey privateKey: PrivateKey, recipientPublicKey publicKey: PublicKey) -> Data {
    encryptMessage(message: data, using: symmetricKey(forPublicKey: publicKey, andMyPrivateKey: privateKey))
}

public func decryptMessage(encryptedMessage data: Data, using symmetricKey: SymmetricKey) -> Data {
    try! ChaChaPoly.open(ChaChaPoly.SealedBox(combined: data), using: symmetricKey)
}

public func decryptMessage(encryptedMessage data: Data, myPrivateKey privateKey: PrivateKey, senderPublicKey publicKey: PublicKey) -> Data {
    decryptMessage(encryptedMessage: data, using: symmetricKey(forPublicKey: publicKey, andMyPrivateKey: privateKey))
}

public class KeyExchange {
    
    private var parties: [Identity : PublicKey] = [:]
    
    public static let shared: KeyExchange = KeyExchange()
    
    private init() {}
    
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

/*
 E2E
 */

public class Participant {
    
    public static let all: [Participant] = {
        [Participant["Bob"], Participant["Alice"], Participant["Eve"], Participant["Julia"]]
    }()
    
    public static func all(without: Participant...) -> [Participant] {
        all.filter { !without.contains($0) }
    }
    
    public var name: String {
        willSet {
            KeyExchange.shared.unregisterIdentity(self.getIdentity())
            KeyExchange.shared.registerIdentity(newValue, withPublicKey: self.keypair.publicKey)
        }
    }
    
    private static var users: [Identity : Participant] = [:]
    
    internal let keypair: Keypair = generateKeys()
    
    private init(name: String) {
        self.name = name
        KeyExchange.shared.registerIdentity(self.getIdentity(), withPublicKey: self.keypair.publicKey)
        MessageDispatch.shared.listen(as: self)
    }
    
    public func getIdentity() -> Identity {
        self.name
    }
    
    public func getPublicKey() -> PublicKey {
        KeyExchange.shared.fetchPublicKeyFor(identity: self.getIdentity())!
    }
    
    public func getChat(forMe me: Participant) -> Chat {
        Chat[me, self]
    }
    
    public func didReceiveMessage(encryptedMessage message: Data, from: Identity) {
        Chat[self, Self[from]].registerReceivedMessage(message: String(data: decryptMessage(encryptedMessage: message, using: Chat[self, Self[from]].chatSymmetricKey), encoding: .utf8) ?? "Decryption Error", from: Self[from])
    }
    
    @objc
    public func receive(_ notification: NSNotification) {
        if let message = notification.userInfo?["message"] as? Data, let from = notification.userInfo?["from"] as? Identity {
            self.didReceiveMessage(encryptedMessage: message, from: from)
        }
    }
    
    public static subscript(_ identity: Identity) -> Participant {
        get {
            if let p = users[identity] {
                return p
            }
            users[identity] = Participant(name: identity)
            return Self[identity]
        }
    }
    
}

extension Participant : Hashable {
    
    public static func == (lhs: Participant, rhs: Participant) -> Bool {
        lhs.getIdentity() == rhs.getIdentity()
    }
    
    public func hash(into hasher: inout Hasher) {
        self.getIdentity().hash(into: &hasher)
    }
    
}

public class MessageDispatch {
    
    private let notificationCenter: NotificationCenter = NotificationCenter.default
    
    public static let shared = MessageDispatch()
    
    public func dispatch(message: Data, from: Participant, to: Participant) {
        notificationCenter.post(name: NSNotification.Name("de.fheuschen.message~" + to.getIdentity()), object: nil, userInfo: ["message" : message, "from" : from.getIdentity(), "to" : to.getIdentity()])
    }
    
    public func listen(as participant: Participant) {
        notificationCenter.addObserver(participant, selector: #selector(participant.receive(_:)), name: NSNotification.Name("de.fheuschen.message~" + participant.getIdentity()), object: nil)
    }
    
}

public class Chat : ObservableObject {
    
    private static var chats: [Participant : Chat] = [:]
    
    @Published public var participants: (Participant, Participant)
    @Published public var messages: [(Participant, String)] = []
    internal var chatSymmetricKey: SymmetricKey {
        symmetricKey(forPublicKey: participants.1.getPublicKey(), andMyPrivateKey: participants.0.keypair.privateKey)
    }
    
    private init(_ me: Participant, with participant2: Participant) {
        self.participants = (me, participant2)
    }
    
    public func sendMessage(message: String) {
        MessageDispatch.shared.dispatch(message: encryptMessage(message: message.data(using: .utf8)!, using: self.chatSymmetricKey), from: participants.0, to: participants.1)
        self.messages.append((self.participants.0, message))
    }
    
    internal func registerReceivedMessage(message: String, from participant: Participant) {
        self.messages.append((participant, message))
    }
    
    public static subscript(_ me: Participant, _ participant2: Participant) -> Chat {
        get {
            if let chat = chats[participant2] {
                return chat
            }
            chats[participant2] = Chat(me, with: participant2)
            return Self[me, participant2]
        }
    }
    
}

/*
 SwiftUI Views
 */

