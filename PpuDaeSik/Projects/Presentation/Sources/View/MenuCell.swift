//
//  MenuCell.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/21/24.
//

import SwiftUI
import Entities
import Shared

/// 조기, 조식, 중식, 석식 분류 및 식단을 나타내는 뷰
struct MenuCell: View {
    let menus: [Entities.Category: [CafeteriaMenu]]
    
    var body: some View {
        ForEach(menus.keys.sorted(), id: \.self) { category in
            VStack {
                ForEach(menus[category]!, id: \.uuid) { menu in
                    HStack {
                        Text(category.rawValue)
                            .foregroundColor(.black40)
                        
                        Spacer()
                        
                        Text(menu.time ?? "")
                            .foregroundColor(.black40)
                    }
                    .font(.body())
                    .frame(width: UIScreen.getWidth(300), alignment: .leading)
                    
                    MenuContent(menu: menu)
                }
            }
            .padding(.bottom)
        }
    }
}
