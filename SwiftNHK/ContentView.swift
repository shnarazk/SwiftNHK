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
        load_data(area: "400", service: channel, apiKey: apiKey)
    }
    var body: some View {
        NavigationSplitView {
            List {
                Button(action: { channel = "g1" }) {
                    HStack {
                        Text("総合")
                        if channel == "g1" {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Button(action: { channel = "e1" }) {
                    HStack {
                        Text("Eテレ")
                        if channel == "e1" {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Button(action: { channel = "e2" }) {
                    HStack {
                        Text("Eテレサブチャンネル")
                        if channel == "e2" {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Button(action: { channel = "r1" }) {
                    HStack {
                        Text("NHK radio1")
                        if channel == "r1" {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Button(action: { channel = "r2" }) {
                    HStack {
                        Text("NHK radio2")
                        if channel == "r2" {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Button(action: { channel = "r3" }) {
                    HStack {
                        Text("NHK FM")
                        if channel == "r3" {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } detail: {
            VStack {
                List {
                    if let p = cp {
                        ForEach([p.previous, p.present, p.following]) { p in
                            VStack(alignment: .leading) {
                                //                                AsyncImage(url: URL(string: "https:" + p.service.logo_s.url)) { image in image.resizable()
                                //                                        .frame(width: 40, height: 40)
                                //                                        .clipped()
                                //                                } placeholder: {
                                //                                    ProgressView()
                                //                                }
                                // .frame(width: 64, height: 64)
                                // .clipped()
                                Text(p.title)
                                    .font(.title)
                                    // .font(.headline)
                                    // .font(.largeTitle)

                                Text(p.start_time)
                                    .padding(.leading)
                                Text(p.subtitle)
                                    // .font(.headline)
                                    .padding()

                            }
                        }
                    } else {
                        Text("fail to load program")
                    }
                }

                .refreshable {
                    channel = "g1"
                }
                //                Picker(selection: $channel, label: EmptyView(), content: {
                //                    Text("総合").tag("g1")
                //                    Text("Eテレ").tag("e1")
                //                    Text("Eテレサブチャンネル").tag("e2")
                //                    Text("NHK radio1").tag("r1")
                //                    Text("NHK radio2").tag("r2")
                //                    Text("NHK FM").tag("r3")
                //                })
                //                .pickerStyle(SegmentedPickerStyle())
                //                .padding(.horizontal, 10)

                //                HStack {
                //                    Text("Key")
                //                        .padding()
                //                    TextField("Key", text: $apiKey)
                //                        .padding()
                //                    Button("Refresh") {
                //                        channel = "g1"
                //                    }
                //                    .padding()
                //                }
            }
        }
        // .backgroundExtensionEffect()
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
