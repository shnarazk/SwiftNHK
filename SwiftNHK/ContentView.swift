//
//  ContentView.swift
//  SwiftNHK
//
//  Created by 楢崎修二 on 2021/07/22.
//

import SwiftUI

struct ContentView: View {
    var list = [(1, "a"), (2, "b")]
    @State var secretKey: String = ""
    @State var secretId: String = ""
    var body: some View {
        VStack {
            Text("Hello, \(secretId)!")
                .padding()
            List {
                ForEach(list, id: \.1) { target in
                    Text("--\(target.1)")
                }
            }
            NavigationView() {
                NavigationLink(destination: SecretsPanel(secretKey: $secretKey, secretId: $secretId)) {
                    Text("Set secrets")
                }
            }
        }
    }
}

struct SecretsPanel: View {
    @Binding var secretKey: String
    @Binding var secretId: String
    var body: some View {
        VStack {
            HStack {
                Text("Sectet")
                    .padding()
                TextField("ID", text: $secretId)
                    .padding()
            }
            HStack {
                Text("KeyId")
                    .padding()
                TextField("Key", text: $secretKey)
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
