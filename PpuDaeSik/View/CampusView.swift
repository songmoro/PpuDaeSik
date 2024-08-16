//
//  CampusView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

struct CampusView: View {
    let namespace: Namespace.ID
    @Binding var selectedCampus: Campus
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Campus.allCases, id: \.self) { campus in
                VStack(spacing: 0) {
                    TextComponent.campusTitle(campus.rawValue, campus == selectedCampus)
                    
                    switch campus {
                    case selectedCampus:
                        CircleComponent.selectedComponentDot
                            .matchedGeometryEffect(id: "campus", in: namespace)
                    default:
                        CircleComponent.unselectedComponentDot
                    }
                }
                .onTapGesture {
                    selectedCampus = campus
                }
                .animation(.default, value: selectedCampus)
                .padding(.trailing)
            }
            .font(.title())
            
            Spacer()
        }
        .padding(.bottom, UIScreen.getHeight(8))
    }
}
