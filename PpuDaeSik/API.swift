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
    case queryByCampus(_ type: QueryType, _ campus: Campus)
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
            return NotionDatabase.status.path()
        case .queryByCampus(let type, _):
            switch type {
            case .restaurant(let isUpdating):
                return NotionDatabase.restaurant(isUpdating: isUpdating).path()
            case .domitory(let isUpdating):
                return NotionDatabase.domitory(isUpdating: isUpdating).path()
            }
        }
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
        switch self {
        case .checkStatus:
            return .requestPlain
        case .queryByCampus(let type, let campus):
            let data = FilterByCampusRequest(queryType: type, campus: campus)
            
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String: String]? {
        MoyaHeader.Notion.header()
    }
}
