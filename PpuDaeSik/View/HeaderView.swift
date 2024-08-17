//
//  HeaderView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

/// 앱 최상단 로고 및 설정 버튼 뷰
struct HeaderView: View {
    @Binding var isSheetShow: Bool
    
    var body: some View {
        HStack {
            ImageComponent.logo(isSheetShow)
            
            TextComponent.mainTitle
            
            Spacer()
            
            Button {
                isSheetShow = true
            } label: {
                ImageComponent.setting
            }
        }
    }
}
