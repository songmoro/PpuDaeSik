//
//  CampusTabViewModel.swift
//  Presentation
//
//  Created by 송재훈 on 6/6/25.
//

import SwiftUI
import Entities
import Shared

extension CampusTab {
    class ViewModel: ObservableObject {
        @Published var selectedCampus: Campus
        
        let cancelBag = CancelBag()
        let container: DIContainer
        let appState: Store<AppState>
        
        init(container: DIContainer) {
            self.container = container
            self.appState = container.appState
            
            self._selectedCampus = .init(initialValue: appState.value.tab.campus)
            
            bind()
        }
        
        func bind() {
            cancelBag.collect {
                $selectedCampus
                    .removeDuplicates()
                    .sink {
                        self.appState[\.tab.campus] = $0
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
