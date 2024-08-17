//
//  MenuView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/16/24.
//

import SwiftUI

struct MealView: View {
    let responseArray: [CafeteriaResponse]
    
    var body: some View {
        ForEach(Category.allCases, id: \.self) { category in
            let filteredResponse = responseArray.filter({ $0.category == category })
            
            if !filteredResponse.isEmpty {
                VStack {
                    TextComponent.categoryText(category.rawValue)
                    
                    ForEach(filteredResponse, id: \.uuid) { response in
                        card(response)
                    }
                }
                .padding(.bottom)
            }
        }
    }
    
    private func card(_ response: CafeteriaResponse) -> some View {
        VStack(alignment: .leading) {
            if let title = response.title {
                TextComponent.menuTitle(title)
            }
            
            TextComponent.menuContent(response.content)
        }
        .padding()
        .frame(width: UIScreen.getWidth(300), alignment: .leading)
        .background {
            RectangleComponent.cardBackground
        }
    }
}
