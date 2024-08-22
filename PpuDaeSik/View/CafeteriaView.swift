//
//  CafeteriaView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

/// 각 식당에 대한 뷰
struct CafeteriaView: View {
    @Binding var bookmark: [Cafeteria]
    let campusCafeteria: [Cafeteria]
    let responseArray: [CafeteriaResponse]
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(campusCafeteria, id: \.self) { cafeteria in
                    VStack {
                        CafeteriaHeaderView(bookmark: $bookmark, cafeteria: cafeteria)
                        MealView(responseArray: responseArray.filter({ $0.cafeteria == cafeteria }))
                    }
                    .id(cafeteria)
                    .padding(.bottom)
                    .padding(.horizontal)
                }
            }
            .onChange(of: bookmark) { _, _ in
                guard let first = campusCafeteria.first else { return }
                
                withAnimation {                
                    proxy.scrollTo(first, anchor: .top)
                }
            }
        }
    }
}
