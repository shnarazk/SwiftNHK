//
//  ContentView.swift
//  SwiftNHK
//
//  Created by 楢崎修二 on 2021/07/22.
//

import SwiftUI

struct ContentView: View {
    @State var secretKey: String = ""
    @State var secretId: String = ""
    var cp: CurrentProgram? {
        get {
            load_data(area: "400", service: "g1", apiKey: secretKey)
        }
    }
    var body: some View {
        VStack {
            List {
                if let p = cp {
                    ForEach([p.previous, p.present, p.following]) { p in
                        HStack {
                            Text(p.start_time)
                            VStack {
                                Text(p.title)
                                Text(p.subtitle)
                            }
                        }
                    }
                } else {
                    Text("fail to load program")
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
