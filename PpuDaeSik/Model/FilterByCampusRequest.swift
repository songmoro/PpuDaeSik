//
//  FilterByCampusRequest.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

struct FilterByCampusRequest: Codable {
    init(property: String, campus: Campus, date: [String]) {
        var code: [Filter.Or.ConditionalExpression]
        
        if property == "MENU_DATE" {
            code = campus.restaurant.map { c in
                Filter.Or.ConditionalExpression(property: "RESTAURANT_CODE", rich_text: Filter.Or.ConditionalExpression.RichText(equals: c.code()))
            }
        }
        else {
            code = campus.domitory.map { c in
                Filter.Or.ConditionalExpression(property: "no", rich_text: Filter.Or.ConditionalExpression.RichText(equals: c.code()))
            }
        }
        
        let condition = date.map { d in
            Filter.Or.ConditionalExpression(property: property, rich_text: Filter.Or.ConditionalExpression.RichText(equals: d))
        }
        
        
        self.filter = Filter(and: [Filter.Or(or: code), Filter.Or(or: condition)])
    }
    
    init(property: String, name: String, date: String, category: [String]) {
        var code: [Filter.Or.ConditionalExpression]
        var categoryType: [Filter.Or.ConditionalExpression]
        
        if property == "MENU_DATE" {
            code = [Filter.Or.ConditionalExpression(property: "RESTAURANT_CODE", rich_text: Filter.Or.ConditionalExpression.RichText(equals: name))]
            categoryType = category.map {
                Filter.Or.ConditionalExpression(property: "MENU_TYPE", rich_text: Filter.Or.ConditionalExpression.RichText(equals: $0))
            }
        }
        else {
            code = [Filter.Or.ConditionalExpression(property: "no", rich_text: Filter.Or.ConditionalExpression.RichText(equals: name))]
            categoryType = category.map {
                 Filter.Or.ConditionalExpression(property: "mealKindGcd", rich_text: Filter.Or.ConditionalExpression.RichText(equals: $0))
            }
        }
        
        let condition = Filter.Or.ConditionalExpression(property: property, rich_text: Filter.Or.ConditionalExpression.RichText(equals: date))
        
        
        self.filter = Filter(and: [Filter.Or(or: code), Filter.Or(or: [condition]), Filter.Or(or: categoryType)])
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
