//: [Previous](@previous)

import Foundation
import CryptoKit
import SwiftUI
import PlaygroundSupport
import E2E

let me = Participant["Bob"], me2 = Participant["Alice"]

/*:
 # Last but not least: Our UI
 Our UI will be a simple SwiftUI layout. The screen will be divided into an upper and a lower half, both displaying an independent Chat App. These two will represent two different people and are connected to each other, so that we can use the upper one to chat with the lower one.
 */

struct ChatApp : View {
    
    var body: some View {
        VStack {
            ChatList(title: "Chats", chats: Participant.all(without: me).map { $0.getChat(forMe: me) })
            Divider()
            ChatList(title: "Chats 2", chats: Participant.all(without: me2).map { $0.getChat(forMe: me2) })
        }
    }
    
}


struct ChatList : View {
    
    @State var title: String
    @State var chats: [Chat]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(chats, id: \.participants.1.name) { s in
                    ChatItem(chat: s)
                }
            }
            .navigationTitle(self.title)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct ChatItem : View {
    
    @State var chat: Chat
    
    var body: some View {
        NavigationLink(destination: ChatView(chat: chat)) {
            HStack {
                Image(systemName: "person")
                VStack(alignment: .leading) {
                    Text(chat.participants.1.getIdentity())
                        .font(.callout)
                }
            }
        }
    }
    
}

struct ChatView : View {
    
    @ObservedObject var chat: Chat
    @State var msg: String = ""
    var body: some View {
        VStack {
            Spacer()
            VStack {
                ScrollView {
                    ForEach(chat.messages, id: \.1.uniquified) { msg in
                        HStack {
                            Text(msg.0.name)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(msg.1)
                                .italic()
                        }
                        .padding(.horizontal)
                    }
                }
            }
            HStack {
                TextField("Type a message", text: $msg)
                Button(action: {
                    self.chat.sendMessage(message: self.msg)
                    self.msg = ""
                }, label: {
                    Image(systemName: "paperplane")
                })
            }.padding(.horizontal)
        }
        .navigationBarTitle(chat.participants.1.name, displayMode: .inline)
    }
    
}

extension String {
    
    var uniquified: String {
        self + UUID().uuidString
    }
    
}

/*:
 # In detail: How can we guarantee independence between the two distinct subapps?
 In order to enable communication between the two imaginary persons, both halfs are connected with each other so that you can use the upper one to chat with the lower one. Whereas in a real-world scenario we would communicate via a network, this is obviously not applicable in this case. However, all communication between the two is performed using the _NotificationCenter_, that is, there is no direct programmatic connection between the two.
 The _NotificationCenter_ therefore simulates the network connection - theoretically, everyone can receive everyone's messages - but they are encrypted...
 
 # Finally...
 ... you can try the entire "app" we just coded using the live view on your right hand side. Admittedly, this app is very simple right now - but you can open the "Alice" chat in the upper window and the "Bob" chat in the bottom window and send messages between these two.
 */

//: [Next](@next)
