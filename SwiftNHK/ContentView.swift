import SwiftData
//
//  ContentView.swift
//  SwiftNHK
//
import SwiftUI

struct ContentView: View {
    @State var debugMode: Bool
    @Environment(\.modelContext) private var context
    @Query var configs: [SwiftNHKConfig]  // = ProcessInfo.processInfo.environment["APIKey"] ?? ""
    @State var tv_programs: CurrentProgramOnAir = CurrentProgramOnAir()
    @State var nr_programs: CurrentProgramOnAir = CurrentProgramOnAir()
    @State var refreshCount: Int = 0
    @State var mediaType = 1
    @State private var editorText1: String = ""
    @State private var editorText2: String = ""
    var config: Config? {
        if let conf = configs.first {
            return Config(config: conf)
        } else {
            return nil
        }
    }
    public func saveConfig(apiKey: String, area: String) {
        if let config = configs.first {
            config.apiKey = apiKey
            config.area = area
        } else {
            let conf = SwiftNHKConfig(apiKey: apiKey, area: area)
            context.insert(conf)
        }
    }
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
                        TextField("Key", text: $editorText1)
                            .onAppear {
                                if let config {
                                    editorText1 = config.apiKey
                                }
                            }
                            .padding()
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("Area")
                            .padding()
                        TextField("Area code", text: $editorText2)
                            .onAppear {
                                if let config {
                                    editorText2 = config.area
                                }
                            }
                            .padding()
                        Spacer()
                    }
                    Button("Save") {
                        saveConfig(apiKey: editorText1, area: editorText2)
                        // mediaType = 1
                    }
                    .padding()
                }
            case 4:
                VStack {
                    Spacer()
                    if let config {
                        Text(
                            "https://api.nhk.or.jp/v2/pg/now/\(config.area)/tv.json?key=\(config.apiKey)"
                        )
                    } else {
                        Text("No saved configration")
                    }
                    HStack {
                        Spacer()
                        Text("Refresh: \(refreshCount)")
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }
            default:
                    VStack{
                        Spacer()
                        HStack {
                            Spacer()
                            Text("No configuration or in debug mode")
                            Button("test") { }
                                .tint(.green)
                            Spacer()
                        }
                        Spacer()
                    }
            }
        }
        .task {
            refreshCount += 1
            if !debugMode, let config {
                tv_programs = await load_data(config: config, service: "tv")
                nr_programs = await load_data(config: config, service: "netradio")
            } else {
                mediaType = 0
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: { mediaType = 1 }) { Image(systemName: "tv") }
                Button(action: { mediaType = 2 }) { Image(systemName: "radio") }
            }
            ToolbarSpacer(.flexible, placement: .primaryAction)
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: { mediaType = 3 }) { Image(systemName: "gear") }
            }
            ToolbarSpacer(.flexible, placement: .primaryAction)
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: {
                    Task {
                        refreshCount += 1
                        if !debugMode, let config {
                            tv_programs = await load_data(config: config, service: "tv")
                            nr_programs = await load_data(config: config, service: "netradio")
                        }
                    }
                }) { Image(systemName: "arrow.clockwise") }
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

#Preview {
    ContentView(debugMode: true)
        .modelContainer(for: SwiftNHKConfig.self)
}
