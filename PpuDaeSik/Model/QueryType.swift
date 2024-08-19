//
//  QueryType.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

enum QueryType: CaseIterable {
    case restaurant, domitory
    
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
