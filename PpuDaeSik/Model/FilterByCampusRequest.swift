//
//  FilterByCampusRequest.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

struct FilterByCampusRequest: Codable {
    init(property: String, campus: Campus, date: [String]) {
        let restaurantArray = Cafeteria.allCases.filter({ $0.campus == campus })
        var code: [Filter.Or.ConditionalExpression]
        
        
        if property == "MENU_DATE" {
            code = restaurantArray.map { restaurant in
                Filter.Or.ConditionalExpression(property: "RESTAURANT_CODE", rich_text: Filter.Or.ConditionalExpression.RichText(equals: restaurant.code))
            }
        }
        else {
            code = restaurantArray.map { restaurant in
                Filter.Or.ConditionalExpression(property: "no", rich_text: Filter.Or.ConditionalExpression.RichText(equals: restaurant.code))
            }
        }
        
        let condition = date.map { d in
            Filter.Or.ConditionalExpression(property: property, rich_text: Filter.Or.ConditionalExpression.RichText(equals: d))
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
