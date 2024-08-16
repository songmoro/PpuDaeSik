//
//  ImageComponent.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/16/24.
//

import SwiftUI

struct ImageComponent {
    /// 로고
    /// - 눈 뜬 로고, 눈 감은 로고
    static func logo(_ condition: Bool) -> some View {
        Image(condition ? "LogoEye" : "Logo")
            .resizable()
            .frame(width: UIScreen.getWidth(50), height: UIScreen.getWidth(50))
    }
    
    /// 설정 심볼
    /// - 톱니바퀴
    static var setting: some View {
        Image(systemName: "gearshape.fill")
            .font(.largeTitle())
            .foregroundColor(.blue100)
    }
    
    /// 북마크 심볼
    /// - 별
    static func star(_ condition: Bool) -> some View {
        Image(systemName: "star.fill")
            .font(.headline())
            .foregroundColor(condition ? .yellow100 : .black20)
    }
}
