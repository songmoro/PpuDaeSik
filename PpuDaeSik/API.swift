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
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json", "Notion-Version": "2022-02-22", "Authorization": "Bearer secret_pjqPKFig0CIkvnm5BwFC8NWueGnV7MuXOYM0qXJeOzr"]
        }
    }
}
