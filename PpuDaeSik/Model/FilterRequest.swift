//
//  FilterRequest.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

struct FilterRequest: Codable {
    init(property: String, date: [String]) {
        let condition = date.map { d in
            Filter.ConditionalExpression(property: property, rich_text: Filter.ConditionalExpression.RichText(equals: d))
        }
        
        self.filter = Filter(or: condition)
    }
    
    var filter: Filter
    
    struct Filter: Codable {
        var or: [ConditionalExpression]
        
        struct ConditionalExpression: Codable {
            var property: String
            var rich_text: RichText
            
            struct RichText: Codable {
                var equals: String
            }
        }
    }
}
