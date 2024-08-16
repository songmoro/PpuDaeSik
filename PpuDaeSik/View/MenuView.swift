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
                        Text(category.rawValue)
                            .font(.body())
                            .foregroundColor(.black40)
                            .frame(width: UIScreen.getWidth(300), alignment: .leading)
                        
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
            Text(name)
                .font(.headline())
                .foregroundColor(.black100)
            
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
                Image(systemName: "star.fill")
                    .font(.headline())
                    .foregroundColor(bookmark.contains(name) ? .yellow100 : .black20)
            }
        }
        .padding(.bottom, UIScreen.getHeight(2))
    }
    
    private func card(_ response: CafeteriaResponse) -> some View {
        VStack(alignment: .leading) {
            if let title = response.title {
                Text(title)
                    .font(.subhead())
                    .foregroundColor(.black100)
                    .padding(.bottom, UIScreen.getHeight(2))
            }
            
            Text(response.content)
                .font(.body())
                .foregroundColor(.black100)
                .padding(.bottom, UIScreen.getHeight(2))
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
