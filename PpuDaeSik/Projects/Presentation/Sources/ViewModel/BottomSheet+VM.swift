//
//  BottomSheetViewModel.swift
//  Presentation
//
//  Created by 송재훈 on 6/6/25.
//

import SwiftUI
import Entities
import Shared

extension BottomSheet {
    class ViewModel: ObservableObject {
        @Published var defaultCampus: Campus
        
        let container: DIContainer
        let cancelBag = CancelBag()
        let appState: Store<AppState>
        let useCases: DIContainer.UseCases
        
        init(container: DIContainer) {
            self.container = container
            self.appState = container.appState
            self.useCases = container.useCases
            
            _defaultCampus = .init(initialValue: appState.value.userData.defaultCampus)
            
            bind()
        }
        
        func bind() {
            cancelBag.collect {
                $defaultCampus
                    .removeDuplicates()
                    .sink {
                        self.appState[\.userData.defaultCampus] = $0
                        self.useCases.defaultCampus.save.execute(defaultCampus: $0)
                    }
            }
        }
    }
}
