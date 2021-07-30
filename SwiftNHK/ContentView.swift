//
//  ContentView.swift
//  SwiftNHK
//
//  Created by 楢崎修二 on 2021/07/22.
//

import SwiftUI

struct ContentView: View {
    @State var secretKey: String = ""
    @State var cp: CurrentProgram?
    var body: some View {
        VStack {
            List {
                if let p = cp {
                    ForEach([p.previous, p.present, p.following]) { p in
                        HStack {
                            Text(p.start_time)
                            AsyncImage(url: URL(string: "https:" + p.service.logo_s.url)) {
                                image in image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 64, height: 64)
                            .clipped()
                            VStack {
                                Text(p.title)
                                    .padding()
                                Text(p.subtitle)
                            }
                        }
                    }
                } else {
                    Text("fail to load program")
                }
            }
            .task {
                cp = load_data(area: "400", service: "g1", apiKey: secretKey)
            }
            .refreshable {
                cp = load_data(area: "400", service: "g1", apiKey: secretKey)
            }
            HStack {
                Text("Key")
                    .padding()
                TextField("Key", text: $secretKey)
                    .padding()
                Button("Refresh") {
                    cp = load_data(area: "400", service: "g1", apiKey: secretKey)
                }
                .padding()
            }
        }
    }
}

struct SecretsPanel: View {
    @Binding var secretKey: String
    var body: some View {
        VStack {

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
