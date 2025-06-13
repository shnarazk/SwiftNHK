//
//  ContentView.swift
//  SwiftNHK
//
//  Created by 楢崎修二 on 2021/07/22.
//

import SwiftUI

struct ContentView: View {
    @State var apiKey: String = ProcessInfo.processInfo.environment["APIKey"] ?? ""
    @State var area: String = "400"
    @State var tv_programs: CurrentProgramOnAir = CurrentProgramOnAir()
    @State var nr_programs: CurrentProgramOnAir = CurrentProgramOnAir()
    @State var refreshCount: Int = 0
    @State var mediaType = 1
    var body: some View {
        VStack {
            switch mediaType {
            case 1:
                if let error = tv_programs.error {
                    Spacer()
                    Text(error)
                } else {
                    List {
                        ChannelView(cp: tv_programs.g1)
                        ChannelView(cp: tv_programs.e1)
                    }
                    .refreshable {
                        mediaType = 1
                    }
                    Spacer()
                }
            case 2:
                if let error = nr_programs.error {
                    Spacer()
                    Text(error)
                } else {
                    List {
                        ChannelView(cp: nr_programs.n1)
                        ChannelView(cp: nr_programs.n2)
                        ChannelView(cp: nr_programs.n3)
                    }
                    .refreshable {
                        mediaType = 2
                    }
                    Spacer()
                }
            case 3:
                VStack {
                    HStack {
                        Spacer()
                        Text("Key")
                            .padding()
                        TextField("Key", text: $apiKey)
                            .padding()
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("Area")
                            .padding()
                        TextField("Area code", text: $area)
                            .padding()
                        Spacer()
                    }
                    Button("Refresh") {
                        mediaType = 1
                    }
                    .padding()
                }
            case 4:
                VStack {
                    Spacer()
                    Text("https://api.nhk.or.jp/v2/pg/now/\(area)/tv.json?key=\(apiKey)")
                    HStack {
                        Spacer()
                        Text("Refresh: \(refreshCount)")
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }
            default: Text("Default")
            }
            Spacer()
            Picker(
                selection: $mediaType,
                label: EmptyView(),
                content: {
                    Text("TV").tag(1)
                    Text("NetRadio").tag(2)
                    Text("secret").tag(3)
                    Text("DEBUG").tag(4)
                }
            )
            .pickerStyle(.segmented)
            .padding(.horizontal, 10)
        }
        .task {
            refreshCount += 1
            tv_programs = await load_data(area: Int(area) ?? 400, service: "tv", apiKey: apiKey)
            nr_programs = await load_data(area: Int(area) ?? 400, service: "netradio", apiKey: apiKey)
        }
    }
    // .backgroundExtensionEffect()
}

struct SecretsPanel: View {
    @Binding var secretKey: String
    var body: some View {
        VStack {

        }
    }
}

#Preview {
    ContentView()
}
