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
                    "9d1235c8a69c4492926e565b2b6aefaa"
                case .밀양:
                    "0bb80c54af3844a2b20f05ad80defb98"
                case .양산:
                    "a9872a2826e9469ebea9721e3ebc20c4"
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
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json", "Notion-Version": "2022-02-22", "Authorization": "Bearer secret_pjqPKFig0CIkvnm5BwFC8NWueGnV7MuXOYM0qXJeOzr"]
        }
    }
}
