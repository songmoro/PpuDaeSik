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
        
        let calendar: Calendar = {
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "ko_KR")
            calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
            
            return calendar
        }()
        
        let condition: [Filter.Or.ConditionalExpression] = calendar.interval().compactMap {
            let dateFormatter = DateFormatter(format: "yyyy-MM-dd")
            
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
    
    init(queryType: QueryType, name: String, category: String) {
        let calendar: Calendar = {
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "ko_KR")
            calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
            
            return calendar
        }()
        
        let date: String = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            var date: Date
            
            if calendar.component(.hour, from: Date()) >= 20 {
                date = calendar.date(byAdding: .day, value: 1, to: Date())!
            }
            else {
                date = Date()
            }
            
            return dateFormatter.string(from: date)
        }()
        
        let property = switch queryType {
        case .restaurant:
            (code: "RESTAURANT_CODE", type: "MENU_TYPE", date: "MENU_DATE")
        case .domitory:
            (code: "no", type: "mealKindGcd", date: "mealDate")
        }
        
        let code = [Filter.Or.ConditionalExpression(property: property.code, rich_text: Filter.Or.ConditionalExpression.RichText(equals: name))]
        let categoryType = Filter.Or.ConditionalExpression(property: property.type, rich_text: Filter.Or.ConditionalExpression.RichText(equals: category))
        let condition = Filter.Or.ConditionalExpression(property: property.date, rich_text: Filter.Or.ConditionalExpression.RichText(equals: date))
        
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
