//
//  WidgetAPI.swift
//  PpuDaeSikWidgetExtension
//
//  Created by 송재훈 on 5/3/24.
//

import SwiftUI
import Moya

enum WidgetAPI {
    case checkStatus
    case queryByRestaurant(isUpdate: Bool, code: String, type: QueryType)
}

extension WidgetAPI: TargetType {
    var baseURL: URL {
        let url = "https://api.notion.com/v1"
        guard let baseURL = URL(string: url) else { fatalError() }
        return baseURL
    }
    
    var path: String {
        switch self {
        case .checkStatus:
            return "/databases/" + "233f1075520f4e38b9fb8350901219fb" + "/query"
        case .queryByRestaurant(let isUpdate, _, let type):
            if isUpdate {
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
        case .queryByRestaurant:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .checkStatus:
            return .requestPlain
        case .queryByRestaurant(_, let code, let type):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            let date = dateFormatter.string(from: Date())
            
            var data: FilterByCampusRequest {
                switch type {
                case .restaurant:
                    FilterByCampusRequest(property: "MENU_DATE", name: code, date: [date])
                case .domitory:
                    FilterByCampusRequest(property: "mealDate", name: code, date: [date])
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
