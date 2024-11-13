//
//  CampusTab.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/13/24.
//

import SwiftUI

struct CampusTab: View {
    @Namespace var namespace
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Campus.allCases, id: \.self) { campus in
                let isSelected = viewModel.isSelected(campus)
                
                Button {
                    viewModel.changeSelectedCampus(to: campus)
                } label: {
                    VStack(spacing: 0) {
                        TextComponent.campusTitle(campus.rawValue, isSelected)
                        
                        if isSelected {
                            CircleComponent.selectedComponentDot
                                .matchedGeometryEffect(id: "campus", in: namespace)
                        }
                        else {
                            CircleComponent.unselectedComponentDot
                        }
                    }
                }
                .disabled(isSelected)
                .padding(.trailing)
            }
            
            Spacer()
        }
        .font(.title())
        .animation(.default, value: viewModel.selectedCampus)
        .padding(.bottom, UIScreen.getHeight(8))
    }
}

extension CampusTab {
    class ViewModel: ObservableObject {
        @Published var selectedCampus: Campus
        
        let container: DIContainer
        let cancelBag = CancelBag()
        
        init(container: DIContainer) {
            self.container = container
            let appState = container.appState
            self._selectedCampus = .init(initialValue: appState.value.selectedTab.campus)
            
            cancelBag.collect {
                $selectedCampus.sink {
                    appState[\.selectedTab.campus] = $0
                }
            }
        }
        
        func changeSelectedCampus(to campus: Campus) {
            selectedCampus = campus
        }
        
        func isSelected(_ campus: Campus) -> Bool {
            selectedCampus == campus
        }
    }
}
