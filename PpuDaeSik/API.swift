//
//  API.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/4/24.
//

import Moya
import SwiftUI

enum API {
    case checkStatus
    case queryDatabase(_ campus: Campus)
    case query(_ type: QueryType, _ backup: Bool? = nil)
    case queryByCampus(_ type: QueryType, _ campus: Campus, _ backup: Bool? = nil)
}

extension API: TargetType {
    var baseURL: URL {
        let url = "https://api.notion.com/v1"
        guard let baseURL = URL(string: url) else { fatalError() }
        return baseURL
    }
    
    var path: String {
        switch self {
        case .checkStatus:
            return "/databases/" + "233f1075520f4e38b9fb8350901219fb" + "/query"
        case .queryDatabase(let campus):
            var databaseID: String {
                switch campus {
                case .부산:
                    "da22b69d795c4e879b77dd657948ea4e"
                case .밀양:
                    "da22b69d795c4e879b77dd657948ea4e"
                case .양산:
                    "da22b69d795c4e879b77dd657948ea4e"
                }
            }
            return "/databases/\(databaseID)/query"
            
        case .query(let type, let backup):
            if backup == nil {
                var databaseId: String {
                    switch type {
                    case .restaurant:
                        "da22b69d795c4e879b77dd657948ea4e"
                    case .domitory:
                        "264bceb5a8ef45a0befbec5d407b37f9"
                    }
                }
                
                return "/databases/\(databaseId)/query"
            }
            else {
                var databaseId: String {
                    switch type {
                    case .restaurant:
                        "912baee21c7643628355569d16aeb8b8"
                    case .domitory:
                        "656bc1391c7843e292a7d89be6567f74"
                    }
                }
                
                return "/databases/\(databaseId)/query"
            }
        case .queryByCampus(let type, _, let backup):
            if backup == nil {
                var databaseId: String {
                    switch type {
                    case .restaurant:
                        "da22b69d795c4e879b77dd657948ea4e"
                    case .domitory:
                        "264bceb5a8ef45a0befbec5d407b37f9"
                    }
                }
                
                return "/databases/\(databaseId)/query"
            }
            else {
                var databaseId: String {
                    switch type {
                    case .restaurant:
                        "912baee21c7643628355569d16aeb8b8"
                    case .domitory:
                        "656bc1391c7843e292a7d89be6567f74"
                    }
                }
                
                return "/databases/\(databaseId)/query"
            }
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkStatus:
            return .post
        case .queryDatabase:
            return .post
        case .query:
            return .post
        case .queryByCampus:
            return.post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .checkStatus:
            return .requestPlain
        case .queryDatabase:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            let current = Calendar.current
            var date = [String]()
            
            if let weekend = current.nextWeekend(startingAfter: Date())?.end {
                for interval in (-8)...(-2) {
                    if let intervalDate = current.date(byAdding: .day, value: interval, to: weekend) {
                        date.append(dateFormatter.string(from: intervalDate))
                    }
                }
            }
            
            let data = FilterRequest(property: "MENU_DATE", date: date)
            
            return .requestJSONEncodable(data)
        case .query(let type, _):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            let current = Calendar.current
            var date = [String]()
            
            if let weekend = current.nextWeekend(startingAfter: Date())?.end {
                for interval in (-8)...(-2) {
                    if let intervalDate = current.date(byAdding: .day, value: interval, to: weekend) {
                        date.append(dateFormatter.string(from: intervalDate))
                    }
                }
            }
            
            var data: FilterRequest {
                switch type {
                case .restaurant:
                    FilterRequest(property: "MENU_DATE", date: date)
                case .domitory:
                    FilterRequest(property: "mealDate", date: date)
                }
            }
            
            return .requestJSONEncodable(data)
            
        case .queryByCampus(let type, let campus, _):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            
            let calendar: Calendar = {
                var calendar = Calendar.current
                calendar.locale = Locale(identifier: "ko_KR")
                calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
                
                return calendar
            }()
            
            let interval: [Int] = switch calendar.component(.weekday, from: Date()) {
            case 1: [ 0,  1,  2,  3,  4,  5,  6]
            case 2: [-1,  0,  1,  2,  3,  4,  5]
            case 3: [-2, -1,  0,  1,  2,  3,  4]
            case 4: [-3, -2, -1,  0,  1,  2,  3]
            case 5: [-4, -3, -2, -1,  0,  1,  2]
            case 6: [-5, -4, -3, -2, -1,  0,  1]
            case 7: [-6, -5, -4, -3, -2, -1,  0]
            default: []
            }
            
            let date = interval.map {
                let date = calendar.date(byAdding: .day, value: $0, to: Date())
                
                return dateFormatter.string(from: date!)
            }.compactMap({ $0 })
            
            var data: FilterByCampusRequest {
                switch type {
                case .restaurant:
                    FilterByCampusRequest(property: "MENU_DATE", campus: campus, date: date)
                case .domitory:
                    FilterByCampusRequest(property: "mealDate", campus: campus, date: date)
                }
            }
            
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json", "Notion-Version": "2022-02-22", "Authorization": "Bearer secret_pjqPKFig0CIkvnm5BwFC8NWueGnV7MuXOYM0qXJeOzr"]
        }
    }
}
