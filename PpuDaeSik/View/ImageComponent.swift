//
//  ImageComponent.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/16/24.
//

import SwiftUI

/// SF 심볼, 이미지와 관련된 뷰 요소
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

struct ImageComponent_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                ImageComponent.logo(true)
                ImageComponent.logo(false)
            }
            ImageComponent.setting
            HStack {
                ImageComponent.star(true)
                ImageComponent.star(false)
            }
        }
    }
}
