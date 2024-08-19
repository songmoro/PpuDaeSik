//
//  QueryType.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

enum QueryType: CaseIterable {
    case restaurant, domitory
    
    func code() -> String {
        switch self {
        case .restaurant:
            "RESTAURANT_CODE"
        case .domitory:
            "no"
        }
    }
    
    func type() -> String {
        switch self {
        case .restaurant:
            "MENU_TYPE"
        case .domitory:
            "mealKindGcd"
        }
    }
    
    func date() -> String {
        switch self {
        case .restaurant:
            "MENU_DATE"
        case .domitory:
            "mealDate"
        }
    }
    
    init?(_ rawValue: String) {
        let queryType: QueryType? = switch rawValue {
        case "restaurant":
                .restaurant
        case "domitory":
                .domitory
        default:
            nil
        }
        
        guard let queryType = queryType else { return nil }
        self = queryType
    }
}
