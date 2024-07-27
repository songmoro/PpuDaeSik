//
//  Category.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

enum Category: String, CaseIterable, Hashable, Codable {
    case 조기, 조식, 중식, 석식
    
    var order: Int {
        switch self {
        case .조기: 0
        case .조식: 1
        case .중식: 2
        case .석식: 3
        }
    }
    
    static func getCategory(mealKindGcd: String) -> Self {
        switch mealKindGcd {
        case "01": .조기
        case "02": .조식
        case "03": .중식
        case "04": .석식
        default: .조기
        }
    }
    
    static func getCategory(menuType: String) -> Self {
        switch menuType {
        case "B": .조식
        case "L": .중식
        case "D": .석식
        default: .조기
        }
    }
}
