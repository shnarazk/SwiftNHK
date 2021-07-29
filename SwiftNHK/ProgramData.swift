//
//  ProgramData.swift
//  ProgramData
//
//  Created by 楢崎修二 on 2021/07/22.
//

import Foundation

struct ProgramData: Decodable {
    // let id = UUID()
    let name: String
    let logo: URL
    let title: String
    let subtitle: String
    let gehres: Array<Int>
}

struct CurrentProgram: Decodable {
    let previous: ProgramData
    let current: ProgramData
    let following: ProgramData
}

func load_data () -> CurrentProgram {
    let area = ""
    let service = ""
    let apikey = ""
    guard let url = URL(string: "https://api.nhk.or.jp/v2/pg/now/\(area)/\(service).json?key=\(apikey)") else {
        fatalError("Invalid URL")
    }
    guard let data = try? Data(contentsOf: url) else {
        fatalError("Can't load")
    }
    let decoder = JSONDecoder()
    let result: CurrentProgram
    do {
        result = try decoder.decode(CurrentProgram.self, from: data)
    }
    catch {
        fatalError("fail to parse JSON")
    }
    return result
}
