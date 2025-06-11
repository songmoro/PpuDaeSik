//
//  MainViewHeaderViewModel.swift
//  Presentation
//
//  Created by 송재훈 on 6/6/25.
//

import SwiftUI
import Entities
import Shared

extension MainViewHeader {
    class ViewModel: ObservableObject {
        @Published var settingSheet: Bool
        
        let cancelBag = CancelBag()
        let container: DIContainer
        let appState: Store<AppState>
        let useCases: DIContainer.UseCases
        
        init(container: DIContainer) {
            self.container = container
            self.appState = container.appState
            self.useCases = container.useCases
            
            self._settingSheet = .init(initialValue: appState.value.routing.mainViewRouting.settingSheet)
            
            bind()
        }
        
        func bind() {
            cancelBag.collect {
                appState.map(\.routing.mainViewRouting.settingSheet)
                    .removeDuplicates()
                    .assign(to: \.settingSheet, on: self)
            }
        }
        
        // MARK: functions
        func showSettingSheet() {
            self.appState[\.routing.mainViewRouting.settingSheet] = true
        }
    }
}
