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
    case query(queryType: QueryType, cafeteria: Cafeteria, _ categoty: String)
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
            return NotionDatabase.status.path()
        case .query(let queryType, let cafeteria, _):
            switch cafeteria {
            case .금정회관교직원식당, .금정회관학생식당, .샛벌회관식당, .학생회관학생식당, .학생회관밀양학생식당, .학생회관밀양교직원식당, .편의동2층양산식당:
                return NotionDatabase.restaurant(isUpdating: queryType.isUpdating()).path()
            case .진리관, .웅비관, .자유관, .비마관, .행림관:
                return NotionDatabase.domitory(isUpdating: queryType.isUpdating()).path()
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
        case .query(let queryType, let cafeteria, let category):
            let data: FilterByCampusRequest = switch cafeteria {
            case .금정회관교직원식당, .금정회관학생식당, .샛벌회관식당, .학생회관학생식당, .학생회관밀양학생식당, .학생회관밀양교직원식당, .편의동2층양산식당:
                FilterByCampusRequest(queryType: queryType, name: cafeteria.code, category: category)
            case .진리관, .웅비관, .자유관, .비마관, .행림관:
                FilterByCampusRequest(queryType: queryType, name: cafeteria.code, category: category)
            }
            
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String: String]? {
        MoyaHeader.Notion.header()
    }
}
