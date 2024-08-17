//
//  CafeteriaHeaderView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

/// 식당 이름과 북마크를 설정할 수 있는 뷰
struct CafeteriaHeaderView: View {
    @Binding var bookmark: [Cafeteria]
    let cafeteria: Cafeteria
    
    var body: some View {
        HStack {
            TextComponent.cafeteriaTitle(cafeteria.name)
            
            Spacer()
            
            ImageComponent.star(bookmark.contains(cafeteria))
                .onTapGesture {
                    if bookmark.contains(cafeteria) {
                        bookmark.removeAll {
                            $0 == cafeteria
                        }
                    }
                    else {
                        bookmark.append(cafeteria)
                    }
                }
        }
        .padding(.bottom, UIScreen.getHeight(2))
    }
}
