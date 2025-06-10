//
//  NotionAPI.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

import Foundation
import Entities
import Shared

public enum NotionAPI: NotionAPIAble {
    case status(type: DeploymentType)
    case restaurant(campus: Campus, isUpdating: Bool)
    case dormitory(campus: Campus, isUpdating: Bool)
    
    public var id: String {
        switch self {
        case .status: "233f1075520f4e38b9fb8350901219fb"
        case .restaurant(_, let isUpdating):
            isUpdating ? "912baee21c7643628355569d16aeb8b8" : "da22b69d795c4e879b77dd657948ea4e"
        case .dormitory(_, let isUpdating):
            isUpdating ? "656bc1391c7843e292a7d89be6567f74" : "264bceb5a8ef45a0befbec5d407b37f9"
        }
    }
    
    public var body: Data? {
        switch self {
        case .status(let type):
            let body: SingleFilter
            
            switch type {
            case .restaurant:
                body = .init(RichTextExpression.init(property: "DB", rich_text: "restaurant"))
            case .dormitory:
                body = .init(RichTextExpression.init(property: "DB", rich_text: "domitory"))
            }
            
            return body.description.data(using: .utf8)
        case .restaurant(let campus, _):
            let cafeteria = Cafeteria.allCases.filter({ $0.campus == campus })
            let calendar = Calendar()
            
            let codeCondition: [RichTextExpression] = cafeteria.map {
                RichTextExpression(property: "RESTAURANT_CODE", rich_text: $0.code)
            }
            
            let dateCondition: [RichTextExpression] = calendar.interval().compactMap {
                guard let date = calendar.date(byAdding: .day, value: $0, to: Date()) else { return nil }
                let formattedDate = DateFormatter(format: "yyyy-MM-dd").string(from: date)
                
                return RichTextExpression(property: "MENU_DATE", rich_text: formattedDate)
            }
            
            let and: And = .init([Or(codeCondition), Or(dateCondition)])
            let body: SingleFilter = .init(and)
            
            return body.description.data(using: .utf8)
        case .dormitory(let campus, _):
            let cafeteria = Cafeteria.allCases.filter({ $0.campus == campus })
            let calendar = Calendar()
            
            let codeCondition: [RichTextExpression] = cafeteria.map {
                RichTextExpression(property: "no", rich_text: $0.code)
            }
            
            let dateCondition: [RichTextExpression] = calendar.interval().compactMap {
                guard let date = calendar.date(byAdding: .day, value: $0, to: Date()) else { return nil }
                let formattedDate = DateFormatter(format: "yyyy-MM-dd").string(from: date)
                
                return RichTextExpression(property: "mealDate", rich_text: formattedDate)
            }
            
            let and: And = .init([Or(codeCondition), Or(dateCondition)])
            let body: SingleFilter = .init(and)
            
            return body.description.data(using: .utf8)
        }
    }
    
    public func request() -> URLRequest {
        var request = URLRequest(url: self.url)
        request.httpMethod = self.method
        request.allHTTPHeaderFields = self.headers
        request.httpBody = self.body
        
        return request
    }
}
