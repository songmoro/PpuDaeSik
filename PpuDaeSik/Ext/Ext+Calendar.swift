//
//  Ext+Calendar.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

extension Calendar {
    init() {
        self = Calendar.current
        self.locale = Locale(identifier: "ko_KR")
        self.timeZone = TimeZone(identifier: "Asia/Seoul")!
    }
    
    func interval() -> [Int] {
        switch self.component(.weekday, from: Date()) {
        case 1: [ 0,  1,  2,  3,  4,  5,  6]
        case 2: [-1,  0,  1,  2,  3,  4,  5]
        case 3: [-2, -1,  0,  1,  2,  3,  4]
        case 4: [-3, -2, -1,  0,  1,  2,  3]
        case 5: [-4, -3, -2, -1,  0,  1,  2]
        case 6: [-5, -4, -3, -2, -1,  0,  1]
        case 7: [-6, -5, -4, -3, -2, -1,  0]
        default: []
        }
    }
}
