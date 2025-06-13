//
//  ChannelView.swift
//  SwiftNHK
//

import SwiftUI

func toTime(from time: String) -> String {
    if let date = ISO8601DateFormatter().date(from: time) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    } else {
        return time // fallback if parsing fails
    }
}
struct ChannelView: View {
    var cp: CurrentProgram?
    var body: some View {
        if let cp = cp {
            if let error = cp.error {
                Text(error)
            } else {
                ForEach(cp.asProgramList(), id: \.id) { p in
                    VStack(alignment: .leading) {
                        HStack {
                            AsyncImage(url: URL(string: "https:\(p.service.logo_s.url)")) { image in
                                image.resizable()
                                    .frame(
                                        width: CGFloat(Int(p.service.logo_s.width) ?? 50),
                                        height: CGFloat(Int(p.service.logo_s.height) ?? 25))
                                    .clipped()
                            } placeholder: {
                                ProgressView()
                            }
                            // .frame(width: 64, height: 64)
                            // .clipped()
                            VStack(alignment: .leading) {
                                Text(p.title)
                                    .font(.headline)
                                // .font(.largeTitle)
                                Text(toTime(from: p.start_time))
                                // .padding(.leading)
                            }
                        }
                        Text(p.subtitle)
                        // .font(.headline)
                        // .padding()
                    }
                }
            }
        }
    }
}

//#Preview {
//    ChannelView(
//        apiKey: ProcessInfo.processInfo.environment["APIKey"] ?? "",
//        channel: "g1"
//    )
//}
