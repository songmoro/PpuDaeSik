//
//  Ext+Color.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/2/24.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double((rgb >> 0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
    
    static let black100 = Color(hex: "000000")
    static let black40 = Color(hex: "000000").opacity(0.4)
    static let black30 = Color(hex: "000000").opacity(0.3)
    static let black20 = Color(hex: "000000").opacity(0.2)
    static let white100 = Color(hex: "FFFFFF")
    static let white40 = Color(hex: "FFFFFF").opacity(0.4)
    static let gray100 = Color(hex: "F9F9F9")
    static let blue100 = Color(hex: "00AAFF")
    static let yellow100 = Color(hex: "FFCC00")
}
