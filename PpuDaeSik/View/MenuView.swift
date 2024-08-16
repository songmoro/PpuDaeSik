//
//  MenuView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/16/24.
//

import SwiftUI

struct MenuView: View {
    @Binding var bookmark: [String]
    let name: String
    let responseArray: [CafeteriaResponse]
    
    var body: some View {
        VStack {
            title
            
            ForEach(Category.allCases, id: \.self) { category in
                let filteredArray = responseArray.filter({ $0.category == category })
                
                if !filteredArray.isEmpty {
                    VStack {
                        TextComponent.categoryText(category.rawValue)
                        
                        ForEach(filteredArray, id: \.uuid) { response in
                            card(response)
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var title: some View {
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
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white100)
                .shadow(radius: 2)
        }
    }
}
