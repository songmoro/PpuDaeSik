//
//  FilterByCampusRequest.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

struct FilterByCampusRequest: Codable {
    init(queryType: QueryType, campus: Campus) {
        let cafeteriaArray = Cafeteria.allCases.filter({ $0.campus == campus })
        let calendar = Calendar()
        
        let condition: [Filter.Or.ConditionalExpression] = calendar.interval().compactMap {
            guard let date = calendar.date(byAdding: .day, value: $0, to: Date()) else { return nil }
            
            let formattedDate = DateFormatter(format: "yyyy-MM-dd").string(from: date)
            
            return Filter.Or.ConditionalExpression(property: queryType.date(), rich_text: Filter.Or.ConditionalExpression.RichText(equals: formattedDate))
        }
        
        let code: [Filter.Or.ConditionalExpression] = cafeteriaArray.map { cafeteria in
            Filter.Or.ConditionalExpression(property: queryType.code(), rich_text: Filter.Or.ConditionalExpression.RichText(equals: cafeteria.code))
        }
        
        self.filter = Filter(and: [Filter.Or(or: code), Filter.Or(or: condition)])
    }
    
    init(queryType: QueryType, name: String, category: String) {
        let calendar = Calendar()
        
        let date: String = {
            let dateFormatter = DateFormatter(format: "YYYY-MM-dd")
            
            let date: Date = switch calendar.component(.hour, from: Date()) {
            case 20...:
                calendar.date(byAdding: .day, value: 1, to: Date())!
            default:
                Date()
            }
            
            return dateFormatter.string(from: date)
        }()
        
        let code = [Filter.Or.ConditionalExpression(property: queryType.code(), rich_text: Filter.Or.ConditionalExpression.RichText(equals: name))]
        let categoryType = Filter.Or.ConditionalExpression(property: queryType.type(), rich_text: Filter.Or.ConditionalExpression.RichText(equals: category))
        let condition = Filter.Or.ConditionalExpression(property: queryType.date(), rich_text: Filter.Or.ConditionalExpression.RichText(equals: date))
        
        self.filter = Filter(and: [Filter.Or(or: code), Filter.Or(or: [condition]), Filter.Or(or: [categoryType])])
    }
    
    var filter: Filter
    
    struct Filter: Codable {
        var and: [Or]
        
        struct Or: Codable {
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
}
