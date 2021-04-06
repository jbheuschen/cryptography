//: [Previous](@previous)

import Foundation
import CryptoKit
import SwiftUI
import PlaygroundSupport

import E2E

let me = Participant["Julian"], me2 = Participant["Benjamin"]

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
                Text(chat.messages.last?.1 ?? "No messages.")
                    .foregroundColor(.gray)
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
                    ForEach(chat.messages, id: \.1) { msg in
                        HStack {
                            Text(msg.0.name)
                                .foregroundColor(.gray)
                            Text(msg.1)
                        }
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





PlaygroundPage.current.setLiveView(ChatApp())

//: [Next](@next)
