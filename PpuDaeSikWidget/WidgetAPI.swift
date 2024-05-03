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
    case queryByRestaurant
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
        case .queryByRestaurant:
            return "/databases/" + "233f1075520f4e38b9fb8350901219fb" + "/query"
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
        case .queryByRestaurant:
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
