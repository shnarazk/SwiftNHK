//
//  ProgramData.swift
//  ProgramData
//
//  Created by 楢崎修二 on 2021/07/22.
//

import Foundation

struct ProgramArea: Decodable, Identifiable {
    let id: String
    let name: String
}

struct ProgramLogo: Decodable {
    let url: String
    let width: String
    let height: String
}

struct ProgramService: Decodable, Identifiable {
    let id: String
    let name: String
    let logo_s: ProgramLogo
    let logo_m: ProgramLogo
    let logo_l: ProgramLogo
}
struct ProgramData: Decodable, Identifiable {
    let id: String
    let event_id: String
    let start_time: String
    let end_time: String
    let area: ProgramArea
    let service: ProgramService
    let title: String
    let subtitle: String
    let genres: Array<String>
}

struct CurrentProgram: Decodable {
    let previous: ProgramData
    let present: ProgramData
    let following: ProgramData
}

struct CurrentProgramOnG1: Decodable {
    let g1: CurrentProgram
}

struct CurrentProgramOnE1: Decodable {
    let e1: CurrentProgram
}

struct NowOnAirG1: Decodable {
    let nowonair_list: CurrentProgramOnG1
}

struct NowOnAirE1: Decodable {
    let nowonair_list:CurrentProgramOnE1
}

func load_data (area: String, service: String, apiKey: String) -> CurrentProgram? {
    let url = "https://api.nhk.or.jp/v2/pg/now/\(area)/\(service).json?key=\(apiKey)"
    guard let source: URL = URL(string: url) else {
        print("Invalid URL: \(url)")
        return nil
    }
    do {
        let x = try Data(contentsOf: source)
        print(x)
    } catch let error { print(error)}
    guard let data = try? Data(contentsOf: source) else {
        print("can't load from \(url)")
        return nil
    }
    let decoder = JSONDecoder()
    switch service {
    case "e1":
        let result: NowOnAirE1
        do {
            result = try decoder.decode(NowOnAirE1.self, from: data)
        }
        catch {
            print("fail to parse JSON \(data)")
            return nil
        }
        return result.nowonair_list.e1
    default:
        let result: NowOnAirG1
        do {
            result = try decoder.decode(NowOnAirG1.self, from: data)
        }
        catch {
            print("fail to parse JSON \(data)")
            return nil
        }
        return result.nowonair_list.g1
    }
}
