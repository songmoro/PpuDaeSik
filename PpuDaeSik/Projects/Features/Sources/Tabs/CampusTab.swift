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
                        Text(campus.rawValue)
                            .foregroundColor(isSelected ? .black100 : .black40)
                            .padding(.bottom, UIScreen.getHeight(6))
                        
                        if isSelected {
                            Circle()
                                .foregroundColor(.blue100)
                                .frame(height: UIScreen.getHeight(5))
                                .matchedGeometryEffect(id: "campus", in: namespace)
                        }
                        else {
                            Circle()
                                .foregroundColor(.clear)
                                .frame(height: UIScreen.getHeight(5))
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
            
            self._selectedCampus = .init(initialValue: appState.value.tab.campus)
            
            bind()
        }
        
        func bind() {
            let appState = container.appState
            
            cancelBag.collect {
                $selectedCampus
                    .removeDuplicates()
                    .sink {
                        appState[\.tab.campus] = $0
                    }
            }
        }
        
        // MARK: functions
        func changeSelectedCampus(to campus: Campus) {
            selectedCampus = campus
        }
        
        func isSelected(_ campus: Campus) -> Bool {
            selectedCampus == campus
        }
    }
}
