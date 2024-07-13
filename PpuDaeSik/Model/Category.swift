//
//  Category.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

enum Category: String, CaseIterable, Hashable, Codable {
    case 조기, 조식, 중식, 석식
    
    func order() -> Int {
        switch self {
        case .조기: 0
        case .조식: 1
        case .중식: 2
        case .석식: 3
        }
    }
}
