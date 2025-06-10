////
////  NotionAPIAble.swift
////  PpuDaeSikWidgetExtension
////
////  Created by 송재훈 on 11/25/24.
////
//
//import SwiftUI
//
//protocol NotionAPIAble {
//    var id: String { get }
//    var path: String { get }
//    var baseUrl: String { get }
//    var url: URL { get }
//    var method: String { get }
//    var headers: [String: String]? { get }
//    func request() -> URLRequest
//}
//
//enum DeploymentType {
//    case restaurant
//    case dormitory
//}
//
//enum NotionAPI: NotionAPIAble {
//    case status(type: DeploymentType)
//    case restaurant(cafeteria: Cafeteria, category: String, isUpdating: Bool)
//    case dormitory(cafeteria: Cafeteria, category: String, isUpdating: Bool)
//    
//    var id: String {
//        switch self {
//        case .status: "233f1075520f4e38b9fb8350901219fb"
//        case .restaurant(_, _, let isUpdating):
//            isUpdating ? "912baee21c7643628355569d16aeb8b8" : "da22b69d795c4e879b77dd657948ea4e"
//        case .dormitory(_, _, let isUpdating):
//            isUpdating ? "656bc1391c7843e292a7d89be6567f74" : "264bceb5a8ef45a0befbec5d407b37f9"
//        }
//    }
//    
//    var path: String {
//        "/databases/" + self.id + "/query"
//    }
//    
//    var baseUrl: String {
//        "https://api.notion.com/v1"
//    }
//    
//    var url: URL {
//        URL(string: baseUrl + path)!
//    }
//    
//    var method: String {
//        "POST"
//    }
//    
//    var headers: [String: String]? {
//        [
//            "Content-Type": "application/json",
//            "Notion-Version": "2022-02-22",
//            "Authorization": "Bearer secret_pjqPKFig0CIkvnm5BwFC8NWueGnV7MuXOYM0qXJeOzr"
//        ]
//    }
//    
//    var body: Data? {
//        switch self {
//        case .status(let type):
//            let body: SingleFilter
//            
//            switch type {
//            case .restaurant:
//                body = .init(RichTextExpression.init(property: "DB", rich_text: "restaurant"))
//            case .dormitory:
//                body = .init(RichTextExpression.init(property: "DB", rich_text: "domitory"))
//            }
//            
//            return body.description.data(using: .utf8)
//        case .restaurant(let cafeteria, let category, _):
//            let calendar = Calendar()
//            let date: String = {
//                let dateFormatter = DateFormatter(format: "YYYY-MM-dd")
//                
//                let date: Date = switch calendar.component(.hour, from: Date()) {
//                case 20...:
//                    calendar.date(byAdding: .day, value: 1, to: Date())!
//                default:
//                    Date()
//                }
//                
//                return dateFormatter.string(from: date)
//            }()
//            
//            let codeCondition = RichTextExpression(property: "RESTAURANT_CODE", rich_text: cafeteria.code)
//            let dateCondition = RichTextExpression(property: "MENU_DATE", rich_text: date)
//            let categoryCondition = RichTextExpression(property: "MENU_TYPE", rich_text: category)
//            
//            let and: And = .init([codeCondition, dateCondition, categoryCondition])
//            let body: SingleFilter = .init(and)
//            
//            return body.description.data(using: .utf8)
//        case .dormitory(let cafeteria, let category, _):
//            let calendar = Calendar()
//            let date: String = {
//                let dateFormatter = DateFormatter(format: "YYYY-MM-dd")
//                
//                let date: Date = switch calendar.component(.hour, from: Date()) {
//                case 20...:
//                    calendar.date(byAdding: .day, value: 1, to: Date())!
//                default:
//                    Date()
//                }
//                
//                return dateFormatter.string(from: date)
//            }()
//            
//            let codeCondition = RichTextExpression(property: "no", rich_text: cafeteria.code)
//            let dateCondition = RichTextExpression(property: "mealDate", rich_text: date)
//            let categoryCondition = RichTextExpression(property: "mealKindGcd", rich_text: category)
//            
//            let and: And = .init([codeCondition, dateCondition, categoryCondition])
//            let body: SingleFilter = .init(and)
//            
//            return body.description.data(using: .utf8)
//        }
//    }
//    
//    func request() -> URLRequest {
//        var request = URLRequest(url: self.url)
//        request.httpMethod = self.method
//        request.allHTTPHeaderFields = self.headers
//        request.httpBody = self.body
//        
//        return request
//    }
//}
