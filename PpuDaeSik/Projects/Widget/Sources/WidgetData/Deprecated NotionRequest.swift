////
////  NotionRequest.swift
////  PpuDaeSikWidgetExtension
////
////  Created by 송재훈 on 11/25/24.
////
//
//protocol ConditionOperator: CustomStringConvertible { }
//
//struct SingleFilter: CustomStringConvertible {
//    let filter: any ConditionOperator
//    
//    init(_ filter: any ConditionOperator) {
//        self.filter = filter
//    }
//    
//    var description: String {
//        """
//        {
//            "filter": \(filter)
//        }
//        """
//    }
//}
//
//struct MultiFilter: CustomStringConvertible {
//    let filter: [any ConditionOperator]
//    
//    var description: String {
//        """
//        {
//            "filter": [ \(filter.map { $0.description + ",\n" }) ]
//        }
//        """
//    }
//}
//
//struct And: ConditionOperator, CustomStringConvertible {
//    let and: [any ConditionOperator]
//    
//    init(_ and: [any ConditionOperator]) {
//        self.and = and
//    }
//    
//    var description: String {
//        """
//        {
//            "and": \(and)
//        }
//        """
//    }
//}
//
//struct Or: ConditionOperator, CustomStringConvertible {
//    let or: [any ConditionOperator]
//    
//    init(_ or: [any ConditionOperator]) {
//        self.or = or
//    }
//    
//    var description: String {
//        """
//        {
//            "or": \(or)
//        }
//        """
//    }
//}
//
//struct RichTextExpression: ConditionOperator, CustomStringConvertible {
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
//    var description: String {
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
