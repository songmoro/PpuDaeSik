//
//  MenuContent.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/21/24.
//

import SwiftUI
import Entities
import Shared

struct MenuContent: View {
    let menu: CafeteriaMenu
    
    var body: some View {
        VStack(alignment: .leading) {
            if let title = menu.title, !title.isEmpty {
                Text(title)
                    .font(.subhead())
                    .foregroundColor(.black100)
                    .padding(.bottom, UIScreen.getHeight(2))
            }
            
            if !menu.content.isEmpty {
                Text(menu.content)
                    .font(.body())
                    .foregroundColor(.black100)
                    .padding(.bottom, UIScreen.getHeight(2))
            }
        }
        .padding()
        .frame(width: UIScreen.getWidth(300), alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white100)
                .shadow(radius: 2)
        }
    }
}
