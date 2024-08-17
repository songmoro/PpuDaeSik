//
//  CafeteriaHeaderView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

struct CafeteriaHeaderView: View {
    @Binding var bookmark: [String]
    let name: String
    
    var body: some View {
        HStack {
            TextComponent.cafeteriaTitle(name)
            
            Spacer()
            
            Button {
                if bookmark.contains(name) {
                    bookmark.removeAll {
                        $0 == name
                    }
                }
                else {
                    bookmark.append(name)
                }
            } label: {
                ImageComponent.star(bookmark.contains(name))
            }
        }
        .padding(.bottom, UIScreen.getHeight(2))
    }
}
