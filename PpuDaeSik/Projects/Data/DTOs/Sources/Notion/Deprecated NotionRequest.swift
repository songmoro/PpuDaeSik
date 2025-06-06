//
//  NotionRequest.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/24/24.
//

//public protocol ConditionOperator: CustomStringConvertible { }
//
//public struct SingleFilter: CustomStringConvertible {
//    let filter: any ConditionOperator
//    
//    init(_ filter: any ConditionOperator) {
//        self.filter = filter
//    }
//    
//    public var description: String {
//        """
//        {
//            "filter": \(filter)
//        }
//        """
//    }
//}
//
//public struct MultiFilter: CustomStringConvertible {
//    let filter: [any ConditionOperator]
//    
//    public var description: String {
//        """
//        {
//            "filter": [ \(filter.map { $0.description + ",\n" }) ]
//        }
//        """
//    }
//}
//
//public struct And: ConditionOperator, CustomStringConvertible {
//    let and: [any ConditionOperator]
//    
//    init(_ and: [any ConditionOperator]) {
//        self.and = and
//    }
//    
//    public var description: String {
//        """
//        {
//            "and": \(and)
//        }
//        """
//    }
//}
//
//public struct Or: ConditionOperator, CustomStringConvertible {
//    let or: [any ConditionOperator]
//    
//    init(_ or: [any ConditionOperator]) {
//        self.or = or
//    }
//    
//    public var description: String {
//        """
//        {
//            "or": \(or)
//        }
//        """
//    }
//}
//
//public struct RichTextExpression: ConditionOperator, CustomStringConvertible {
//    let property: String
//    let rich_text: RichText
//    
//    init(property: String, rich_text: String) {
//        self.property = property
//        self.rich_text = .init(equals: rich_text)
//    }
//    
//    struct RichText: Codable {
//        let equals: String
//    }
//    
//    public var description: String {
//        """
//        {
//            "property": "\(property)",
//            "rich_text": {
//                "equals": "\(rich_text.equals)"
//            }
//        }
//        """
//    }
//}
