//
//  SwiftNHKConfig.swift
//  SwiftNHK
//
import SwiftUI
import SwiftData

@Model
final class SwiftNHKConfig {
    @Attribute(.unique) var apiKey: String = ""
    var area: String = ""
    init(apiKey: String, area: String) {
        self.apiKey = apiKey
        self.area = area
    }
}

struct Config {
    let apiKey: String
    let area: String
    init(config: SwiftNHKConfig) {
        self.apiKey = config.apiKey
        self.area = config.area
    }
}
