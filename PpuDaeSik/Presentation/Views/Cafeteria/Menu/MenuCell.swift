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
                ForEach(responseArray[category]!, id: \.uuid) { response in
                    HStack {
                        Text(category.rawValue)
                            .foregroundColor(.black40)
                        
                        Spacer()
                        
                        Text(category.openingHours(by: response))
                            .foregroundColor(.black40)
                    }
                    .font(.body())
                    .frame(width: UIScreen.getWidth(300), alignment: .leading)
                    
                    MenuContent(response: response)
                }
            }
            .padding(.bottom)
        }
    }
}
