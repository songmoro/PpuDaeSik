//
//  API.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/4/24.
//

import Moya
import SwiftUI

enum API {
    case queryDatabase(_ campus: Campus)
}

extension API: TargetType {
    var baseURL: URL {
        let url = "https://api.notion.com/v1"
        guard let baseURL = URL(string: url) else { fatalError() }
        return baseURL
    }
    
    var path: String {
        switch self {
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .queryDatabase:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
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
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json", "Notion-Version": "2022-02-22", "Authorization": "Bearer secret_pjqPKFig0CIkvnm5BwFC8NWueGnV7MuXOYM0qXJeOzr"]
        }
    }
}
