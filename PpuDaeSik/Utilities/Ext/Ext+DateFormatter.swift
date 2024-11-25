//
//  Ext+DateFormatter.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        self.dateFormat = format
        self.timeZone = TimeZone(identifier: "Asia/Seoul")
    }
}
