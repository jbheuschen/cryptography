//: [Previous](@previous)

import Foundation
import CryptoKit

/*:
 # The End-to-End Implementation
 
 ## The Participants
 
 First of all, we are going to declare a _Participant_ class. Instances of this class are representing a participant in a chat conversation.
 */

public class Participant {
    
    /*
     These'll make it easier for us later on as we're in a showcase scenario.
     */
    public static let all: [Participant] = {
        [Participant["Julian"], Participant["Mario"], Participant["Regina"], Participant["Benjamin"]]
    }()
    
    public static func all(without: Participant...) -> [Participant] {
        all.filter { !without.contains($0) }
    }
    
    //When changing the name, the public key will be re-registered with our keystore.
    public var name: String {
        willSet {
            KeyExchange.shared.unregisterIdentity(self.getIdentity())
            KeyExchange.shared.registerIdentity(newValue, withPublicKey: self.keypair.publicKey)
        }
    }
    
    //This dictionary keeps track of all existing participants in order to prevent multiple equally-named participants from existing, thus preventing key conflicts.
    private static var users: [Identity : Participant] = [:]
    
    //Initially, a newly generated keypair will be used. Refer to the sixth page for details.
    internal let keypair: Keypair = generateKeys()
    
    //We're declaring our initializer privately as we want to use the subscript in order to access our uniquely-named participants.
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
    
}

/*:
 As mentioned earlier, we want to have uniquely-named participants and thus allow instance-retrieval through this subscript only.
 */

public extension Participant {
    
    static subscript(_ identity: Identity) -> Participant {
        get {
            if let p = users[identity] {
                return p
            }
            users[identity] = Participant(name: identity)
            return Self[identity]
        }
    }
    
}

/*:
 At this point, we're implementing the message receival process - that is, the extraction of the raw message as well as its decryption using our private key.
 */

public extension Participant {
    
    func didReceiveMessage(encryptedMessage message: Data, from: Identity) {
        Chat[self, Self[from]].registerReceivedMessage(message: String(data: decryptMessage(encryptedMessage: message, using: Chat[self, Self[from]].chatSymmetricKey), encoding: .utf8) ?? "Decryption Error", from: Self[from])
    }
    
    @objc
    func receive(_ notification: NSNotification) {
        if let message = notification.userInfo?["message"] as? Data, let from = notification.userInfo?["from"] as? Identity {
            self.didReceiveMessage(encryptedMessage: message, from: from)
        }
    }
    
}

/*:
 Lastly, we have to make _Participant_ conform to _Hashable_ in order to be able to use it as keys in a dictionary.
 */

extension Participant : Hashable {
    
    public static func == (lhs: Participant, rhs: Participant) -> Bool {
        lhs.getIdentity() == rhs.getIdentity()
    }
    
    public func hash(into hasher: inout Hasher) {
        self.getIdentity().hash(into: &hasher)
    }
    
}

/*:
 ## MessageDispatch
 Our next class is the _MessageDispatch_. We're implementing this as a singleton; its purpose is to send and enable _Participants_ to receive the raw (i.e., encrypted) data via the _NotificationCenter_.
 */

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

/*:
 ## Chat
 Instances of _Chat_ represent a conversation between two _Participants_. Its direct purpose is to keep track of chat messages, as well as to en- and decrypt them upon sending and receival.
 Moreover, we're making this class a Combine-_ObservableObject_ and have the _Published_-property wrapper applied to the _participants_-tuple as well as the _messages_-array. That way, our SwiftUI view will automatically update itself upon message receival.
 */

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
    
}

/*:
 As with _Participants_, we want _Chats_, too, to be unique to their _Participant_-tuple. Hence, we declared our intializer private (see above) and are now declaring a subscript. As a side effect, this increases code-readability as well.
 */
public extension Chat {
    
    static subscript(_ me: Participant, _ participant2: Participant) -> Chat {
        get {
            if let chat = chats[participant2] {
                return chat
            }
            chats[participant2] = Chat(me, with: participant2)
            return Self[me, participant2]
        }
    }
    
}

//: [Next](@next)
