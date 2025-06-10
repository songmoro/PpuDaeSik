//
//  WeekTabViewModel.swift
//  Presentation
//
//  Created by 송재훈 on 6/6/25.
//

import SwiftUI
import Entities
import Shared

extension WeekTab {
    class ViewModel: ObservableObject {
        @Published var selectedWeekComponent: WeekComponent
        
        /// 1주
        /// - 일, 월, 화, 수, 목, 금, 토
        /// - n, n+1, ..., n+5, n+6일
        let weekComponentArray: [WeekComponent]
        
        let cancelBag = CancelBag()
        let container: DIContainer
        let appState: Store<AppState>
        
        init(container: DIContainer) {
            self.container = container
            self.appState = container.appState
            
            self._selectedWeekComponent = .init(initialValue: appState.value.tab.weekComponent)
            self.weekComponentArray = WeekComponent.calculateCurrentWeek()
            
            bind()
        }
        
        func bind() {
            let appState = container.appState
            
            cancelBag.collect {
                $selectedWeekComponent
                    .removeDuplicates()
                    .sink {
                        appState[\.tab.weekComponent] = $0
                    }
            }
        }
        
        // MARK: functions
        func changeSelectedWeekComponent(to weekComponent: WeekComponent) {
            selectedWeekComponent = weekComponent
        }
        
        func isSelected(_ weekComponent: WeekComponent) -> Bool {
            selectedWeekComponent == weekComponent
        }
        
        func isToday(_ weekComponent: WeekComponent) -> Bool {
            WeekComponent.getToday() == weekComponent
        }
    }
}
