//
//  CircleComponent.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/16/24.
//

import SwiftUI

/// 원과 관련된 뷰 요소
struct CircleComponent {
    /// 선택된 탭 점
    /// - 선택한 캠퍼스, 요일 파란 점
    static var selectedComponentDot: some View {
        Circle()
            .foregroundColor(.blue100)
            .frame(height: UIScreen.getHeight(5))
    }
    
    /// 선택되지 않은 탭 점
    /// - 선택되지 않은 캠퍼스, 요일 빈 점
    static var unselectedComponentDot: some View {
        Circle()
            .foregroundColor(.clear)
            .frame(height: UIScreen.getHeight(5))
    }
}

struct CircleComponent_Preview: PreviewProvider {
    static var previews: some View {
        HStack {
            CircleComponent.selectedComponentDot
            CircleComponent.unselectedComponentDot
        }
    }
}
