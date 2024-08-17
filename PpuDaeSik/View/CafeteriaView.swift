//
//  CafeteriaView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

struct CafeteriaView: View {
    @Binding var bookmark: [String]
    let selectedCampus: Campus
    let responseArray: [CafeteriaResponse]
    
    var body: some View {
        ScrollView {
            ForEach(Cafeteria.allCases.filter({ $0.campus == selectedCampus }), id: \.self) { cafeteria in
                VStack {
                    CafeteriaHeaderView(bookmark: $bookmark, name: cafeteria.name)
                    MealView(responseArray: responseArray.filter({ $0.cafeteria == cafeteria }))
                }
                .padding(.bottom)
                .padding(.horizontal)
            }
        }
    }
}
