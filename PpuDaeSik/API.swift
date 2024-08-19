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
    case queryByCampus(_ type: QueryType, _ campus: Campus, _ deploymentStatus: DeploymentStatus)
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
        case .queryByCampus(let type, _, let deploymentStatus):
            switch type {
            case .restaurant: return NotionDatabase.restaurant(deploymentStatus).path()
            case .domitory: return NotionDatabase.domitory(deploymentStatus).path()
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
        case .queryByCampus(let type, let campus, _):
            let dateFormatter = DateFormatter(format: "yyyy-MM-dd")
            
            let calendar: Calendar = {
                var calendar = Calendar.current
                calendar.locale = Locale(identifier: "ko_KR")
                calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
                
                return calendar
            }()
            
            let interval = calendar.interval()
            
            let date = interval.map {
                let date = calendar.date(byAdding: .day, value: $0, to: Date())
                
                return dateFormatter.string(from: date!)
            }.compactMap({ $0 })
            
            let data = FilterByCampusRequest(queryType: type, campus: campus, date: date)
            
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String: String]? {
        MoyaHeader.Notion.header()
    }
}
