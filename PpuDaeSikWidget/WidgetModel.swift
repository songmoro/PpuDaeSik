////
////  WidgetModel.swift
////  PpuDaeSik
////
////  Created by 송재훈 on 5/3/24.
////
//
//import Foundation
//
//struct CheckDatabase: Codable {
//    var results: [CheckProperties]
//    
//    struct CheckProperties: Codable {
//        var properties: [String: CheckProperty]
//        
//        struct CheckProperty: Codable {
//            var type: String
//            var title: [RichText]?
//            var rich_text: [RichText]?
//            
//            struct RichText: Codable {
//                var plain_text: String
//            }
//        }
//    }
//}
//
//enum QueryType: String, CaseIterable {
//    case restaurant, domitory
//}
