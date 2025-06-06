//
//  Category.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

public enum Category: String, CaseIterable, Hashable, Codable {
    case 조기, 조식, 중식, 석식
    
    init?(_ rawValue: String) {
        let category: Category? = switch rawValue {
        case "01": .조기
        case "02", "B": .조식
        case "03", "L": .중식
        case "04", "D": .석식
        default: nil
        }
        
        guard let category = category else { return nil }
        self = category
    }
    
//    func openingHours(by response: CafeteriaResponse) -> String {
//        switch self {
//        case .조기: ""
//        case .조식: response.breakfastTime ?? ""
//        case .중식: response.lunchTime ?? ""
//        case .석식: response.dinnerTime ?? ""
//        }
//    }
}

extension Category: Comparable {
    public static func < (lhs: Category, rhs: Category) -> Bool {
        lhs.toInt() < rhs.toInt()
    }
    
    func toInt() -> Int {
        switch self {
        case .조기: 0
        case .조식: 1
        case .중식: 2
        case .석식: 3
        }
    }
}
