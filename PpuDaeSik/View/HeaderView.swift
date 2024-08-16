//
//  HeaderView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

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
