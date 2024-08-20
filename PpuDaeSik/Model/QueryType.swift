//
//  QueryType.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

enum QueryType {
    case restaurant(isUpdating: Bool), domitory(isUpdating: Bool)
    
    init?(_ properties: Properties) {
        let properties = properties.toDict()
        
        let isUpdating: Bool? = switch properties["Status"] {
        case "Done":
            false
        case "Update":
            true
        default:
            nil
        }
        
        guard let isUpdating = isUpdating else { return nil }
        
        let queryType: QueryType? = switch properties["DB"] {
        case "restaurant":
                .restaurant(isUpdating: isUpdating)
        case "domitory":
                .domitory(isUpdating: isUpdating)
        default:
            nil
        }
        
        guard let queryType = queryType else { return nil }
        
        self = queryType
    }
    
    func isUpdating() -> Bool {
        switch self {
        case .restaurant(let isUpdating):
            isUpdating
        case .domitory(let isUpdating):
            isUpdating
        }
    }
    
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
}
