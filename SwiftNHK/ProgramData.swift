//
//  ProgramData.swift
//  ProgramData
//
//  Created by 楢崎修二 on 2021/07/22.
//

import Foundation

struct ProgramData {
    let name: String
    let logo: URL
    let title: String
    let subtitle: String
    let gehres: Array<Int>
}

struct CurrentProgram {
    let previous: ProgramData
    let current: ProgramData
    let following: ProgramData
}

func load_data () {
    let area=""
    let service=""
    let apikey=""
    let url = "https://api.nhk.or.jp/v2/pg/now/\(area)/\(service).json?key=\(apikey)"
}
