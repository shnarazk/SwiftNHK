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
    var time: Date? {
        parseDate(start_time)
    }
    let end_time: String
    let area: ProgramArea
    let service: ProgramService
    let title: String
    let subtitle: String
    let genres: [String]
}

struct CurrentProgram: Decodable {
    let previous: ProgramData?
    let present: ProgramData?
    let following: ProgramData?
    let error: String?
    func asProgramList() -> [ProgramData] {
        [previous, present, following].filter { $0 != nil }.map { $0! }
    }
}

struct CurrentProgramOnAir: Decodable {
    var g1: CurrentProgram? = nil
    var g2: CurrentProgram? = nil
    var e1: CurrentProgram? = nil
    var e2: CurrentProgram? = nil
    var r1: CurrentProgram? = nil
    var r2: CurrentProgram? = nil
    var r3: CurrentProgram? = nil
    var n1: CurrentProgram? = nil
    var n2: CurrentProgram? = nil
    var n3: CurrentProgram? = nil
    var error: String? = nil
}

struct NowOnAir: Decodable {
    let nowonair_list: CurrentProgramOnAir
}

/// type for rate limit error
/// {
///    "fault": {
///        "faultstring":" Rate limit quota violation. Quota limit  exceeded. Identifier : ...",
///        "detail": {
///            "errorcode":"policies.ratelimit.QuotaViolation"
///        }
///    }
///}
struct RateLimitErrorErrorCode: Decodable {
    let errorcode: String
}
struct RateLimitErrorDetail: Decodable {
    let faultstring: String
    let detail: RateLimitErrorErrorCode
}
struct RateLimitError: Decodable {
    let fault: RateLimitErrorDetail
}

@concurrent
func load_data(config: Config, service: String) async -> CurrentProgramOnAir {
    /// https://api-portal.nhk.or.jp/doc-now-v2-con
    let url = "https://api.nhk.or.jp/v2/pg/now/\(config.area)/\(service).json?key=\(config.apiKey)"
    guard let source: URL = URL(string: url) else {
        print("Invalid URL: \(url)")
        return CurrentProgramOnAir(error: "Invalid URL: \(url)")
    }
    //    guard let data = try? Data(contentsOf: source) else {
    //        print("Can't load from \(url)")
    //        return CurrentProgramOnAir(error: "Can't load from \(url)")
    //    }
    do {
        let (data, _) = try await URLSession.shared.data(from: source)
        let decoder = JSONDecoder()
        let result: NowOnAir
        do {
            // print(String(data: data, encoding: .utf8))
            result = try decoder.decode(NowOnAir.self, from: data)
            return result.nowonair_list
        } catch {
            do {
                let _ = try decoder.decode(RateLimitError.self, from: data)
                return CurrentProgramOnAir(error: "Rate limit exceeded")
            } catch {
                return CurrentProgramOnAir(
                    error:
                        "Fail to parse data: \(String(describing: String(data: data, encoding: .utf8))): \(error)"
                )
            }
        }

    } catch {
        return CurrentProgramOnAir(error: "Error in URL session \(error)")
    }

}

func parseDate(_ str: String) -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-d"
    if let date = formatter.date(from: str) {
        return date
    } else {
        return nil
    }
}
