import SwiftUI
import Foundation
import PlaygroundSupport

struct IntroLiveView : View {
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "person.crop.square")
                VStack {
                    Text("Bob")
                        .bold()
                    Text("This is Bob. He wants to securely communicate with Alice.")
                }
            }
            HStack {
                Image(systemName: "person.crop.square")
                VStack {
                    Text("Alice")
                        .bold()
                    Text("This is Alice. She wants to securely communicate with Bob, too.")
                }
            }
            HStack {
                Image(systemName: "person.crop.square")
                VStack {
                    Text("Eve")
                        .bold()
                    Text("This is Eve. She doesn't like Bob and Alice and tries to intercept their communication.")
                }
            }
            Spacer()
        }
    }
    
}

PlaygroundPage.current.setLiveView(IntroLiveView())
