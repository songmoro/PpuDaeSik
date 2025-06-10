//
//  CafeteriaViewViewModel.swift
//  Presentation
//
//  Created by 송재훈 on 6/6/25.
//

import SwiftUI
import Entities
import Shared

extension CafeteriaView {
    class ViewModel: ObservableObject {
        let cafeteria: [Cafeteria]
        
        let cancelBag = CancelBag()
        let container: DIContainer
        let appState: Store<AppState>
        let useCases: DIContainer.UseCases
        
        @Published var bookmark: [Cafeteria]
        @Published var filterdCafeteriaMenus: [CafeteriaMenu]
        
        init(container: DIContainer) {
            self.container = container
            self.appState = container.appState
            self.useCases = container.useCases
            
            self._bookmark = .init(initialValue: appState.value.userData.bookmark)
            self._filterdCafeteriaMenus = .init(initialValue: appState.value.cafeteria.filterByDay)
            
            self.cafeteria = appState[\.cafeteria.list]
            
            bind()
        }
        
        func bind() {
            let appState = container.appState
            
            cancelBag.collect {
                appState.map(\.cafeteria.filterByDay)
                    .removeDuplicates()
                    .assign(to: \.filterdCafeteriaMenus, on: self)
                
                appState.map(\.userData.bookmark)
                    .removeDuplicates()
                    .assign(to: \.bookmark, on: self)
            }
        }
        
        // MARK: functions
        func transform(by cafeteria: Cafeteria) -> [Entities.Category: [CafeteriaMenu]] {
            var dict: [Entities.Category: [CafeteriaMenu]] = [:]
            
            let sorted = filterdCafeteriaMenus.sorted(by: { $0.category < $1.category })
            
            sorted.forEach {
                if $0.cafeteria == cafeteria {
                    dict[$0.category, default: []].append($0)
                }
            }
            
            return dict
        }
    }
}
