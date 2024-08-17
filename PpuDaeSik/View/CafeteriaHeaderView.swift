//
//  CafeteriaHeaderView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

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
