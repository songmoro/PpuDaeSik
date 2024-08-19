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
        let property = switch queryType {
        case .restaurant:
            (code: "RESTAURANT_CODE", date: "MENU_DATE")
        case .domitory:
            (code: "no", date: "menuDate")
        }
        
        let dateFormatter = DateFormatter(format: "yyyy-MM-dd")
        
        let calendar: Calendar = {
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "ko_KR")
            calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
            
            return calendar
        }()
        
        let interval = calendar.interval()
        
        let condition: [Filter.Or.ConditionalExpression] = interval.compactMap {
            let date = calendar.date(byAdding: .day, value: $0, to: Date())
            guard let date = date else { return nil }
            
            let formattedDate = dateFormatter.string(from: date)
            
            return Filter.Or.ConditionalExpression(property: property.date, rich_text: Filter.Or.ConditionalExpression.RichText(equals: formattedDate))
        }
        
        let code: [Filter.Or.ConditionalExpression] = cafeteriaArray.map { cafeteria in
            Filter.Or.ConditionalExpression(property: property.code, rich_text: Filter.Or.ConditionalExpression.RichText(equals: cafeteria.code))
        }
        
        self.filter = Filter(and: [Filter.Or(or: code), Filter.Or(or: condition)])
    }
    
    init(property: String, name: String, date: String, category: String) {
        var code: [Filter.Or.ConditionalExpression]
        var categoryType: Filter.Or.ConditionalExpression
        
        if property == "MENU_DATE" {
            code = [Filter.Or.ConditionalExpression(property: "RESTAURANT_CODE", rich_text: Filter.Or.ConditionalExpression.RichText(equals: name))]
            categoryType = Filter.Or.ConditionalExpression(property: "MENU_TYPE", rich_text: Filter.Or.ConditionalExpression.RichText(equals: category))
        }
        else {
            code = [Filter.Or.ConditionalExpression(property: "no", rich_text: Filter.Or.ConditionalExpression.RichText(equals: name))]
            categoryType = Filter.Or.ConditionalExpression(property: "mealKindGcd", rich_text: Filter.Or.ConditionalExpression.RichText(equals: category))
        }
        
        let condition = Filter.Or.ConditionalExpression(property: property, rich_text: Filter.Or.ConditionalExpression.RichText(equals: date))
        
        
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
