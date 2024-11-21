//
//  RectangleComponent.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/16/24.
//

import SwiftUI

/// 사각형과 관련된 뷰 요소
struct RectangleComponent {
    /// 카드 배경요소
    /// - 흰 배경
    static var cardBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundColor(.white100)
            .shadow(radius: 2)
    }
    
    /// 시트 홀더
    static var holdBar: some View {
        RoundedRectangle(cornerRadius: 2.5)
            .foregroundColor(.darkGray100)
            .frame(width: UIScreen.getWidth(36), height: UIScreen.getHeight(5))
    }
}

struct RectangleComponent_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            RectangleComponent.cardBackground
                .frame(width: UIScreen.getWidth(300), height: UIScreen.getHeight(200), alignment: .leading)
            RectangleComponent.holdBar
        }
    }
}

