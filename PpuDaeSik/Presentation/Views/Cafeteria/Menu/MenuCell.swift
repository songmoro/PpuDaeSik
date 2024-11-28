//
//  MenuCell.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/21/24.
//

import SwiftUI

/// 조기, 조식, 중식, 석식 분류 및 식단을 나타내는 뷰
struct MenuCell: View {
    let responseArray: [Category: [CafeteriaResponse]]
    
    var body: some View {
        ForEach(responseArray.keys.sorted(), id: \.self) { category in
            VStack {
                Text(category.rawValue)
                    .font(.body())
                    .foregroundColor(.black40)
                    .frame(width: UIScreen.getWidth(300), alignment: .leading)
                
                ForEach(responseArray[category]!, id: \.uuid) { response in
                    MenuContent(response: response)
                }
            }
            .padding(.bottom)
        }
    }
}
