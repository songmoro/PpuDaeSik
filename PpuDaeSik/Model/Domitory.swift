//
//  Domitory.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

enum Domitory: Int, CaseIterable, Hashable, Codable {
    case 진리관 = 2
    case 비마관 = 3
    case 웅비관 = 11
    case 행림관 = 12
    case 자유관 = 13
    
    func order() -> Int {
        switch self {
        case .진리관: 0
        case .웅비관: 1
        case .자유관: 2
        case .비마관: 3
        case .행림관: 4
        }
    }
    
    func campus() -> Campus {
        switch self {
        case .진리관, .웅비관, .자유관: Campus.부산
        case .비마관: Campus.밀양
        case .행림관: Campus.양산
        }
    }
    
    func code() -> String {
        switch self {
        case .진리관: "2"
        case .웅비관: "11"
        case .자유관: "13"
        case .비마관: "3"
        case .행림관: "12"
        }
    }
    
    func name() -> String {
        switch self {
        case .진리관: "진리관"
        case .웅비관: "웅비관"
        case .자유관: "자유관"
        case .비마관: "비마관"
        case .행림관: "행림관"
        }
    }
}
