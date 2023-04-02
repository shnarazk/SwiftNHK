//
//  ContentView.swift
//  SwiftNHK
//
//  Created by 楢崎修二 on 2021/07/22.
//

import SwiftUI

struct ContentView: View {
    @State var apiKey: String = ProcessInfo.processInfo.environment["APIKey"] ?? ""
    @State var channel: String
    var cp: CurrentProgram? {
        get {
            load_data(area: "400", service: channel, apiKey: apiKey)
        }
    }
    var body: some View {
        VStack {
            List {
                if let p = cp {
                    ForEach([p.previous, p.present, p.following]) { p in
                        HStack {
                            Text(p.start_time)
                            AsyncImage(url: URL(string: "https:" + p.service.logo_s.url)) { image in image.resizable()
                                    .frame(width: 40, height: 40)
                                    .clipped()
                            } placeholder: {
                                ProgressView()
                            }
                            // .frame(width: 64, height: 64)
                            // .clipped()
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

            .refreshable {
                channel = "g1"
            }
            Picker(selection: $channel, label: EmptyView(), content: {
                Text("総合").tag("g1")
                Text("Eテレ").tag("e1")
                Text("Eテレサブチャンネル").tag("e2")
                Text("NHK radio1").tag("r1")
                Text("NHK radio2").tag("r2")
                Text("NHK FM").tag("r3")
            })
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 10)
            HStack {
                Text("Key")
                    .padding()
                TextField("Key", text: $apiKey)
                    .padding()
                Button("Refresh") {
                    channel = "g1"
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
        ContentView(channel: "g1")
    }
}
