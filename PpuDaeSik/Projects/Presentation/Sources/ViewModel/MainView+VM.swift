//
//  MainViewViewModel.swift
//  Presentation
//
//  Created by 송재훈 on 6/6/25.
//

import SwiftUI
import Combine
import Entities
import UseCases
import Shared
import Logger

public extension MainView {
    struct Routing: Equatable {
        public var settingSheet: Bool
        
        public init(settingSheet: Bool) {
            self.settingSheet = settingSheet
        }
    }
}

public extension MainView {
    class ViewModel: ObservableObject {
        let cancelBag = CancelBag()
        let container: DIContainer
        let appState: Store<AppState>
        let useCases: DIContainer.UseCases
        
        /// 현재 선택된 요일
        @Published var selectedWeekComponent: WeekComponent = .getToday()
        
        /// MainView 라우팅
        @Published var routingState: MainView.Routing
        
        /// 식당의 식단들
        @Published var cafeteriaMenus: Loadable<[CafeteriaMenu]>
        
        /// 선택한 캠퍼스
        @Published var selectedCampus: Campus
        
        /// 사용자가 설정한 앱 시작 시 먼저 보여줄 식당 목록
        @Published var bookmark: [Cafeteria]
        
        public init(container: DIContainer) {
            self.container = container
            self.appState = container.appState
            self.useCases = container.useCases
            
            self._selectedWeekComponent = .init(initialValue: appState.value.tab.weekComponent)
            self._routingState = .init(initialValue: appState.value.routing.mainViewRouting)
            self._cafeteriaMenus = .init(initialValue: appState.value.cafeteria.menus)
            self._selectedCampus = .init(initialValue: appState.value.tab.campus)
            self._bookmark = .init(initialValue: appState.value.userData.bookmark)
            
            loadBookmark()
            loadDefaultCampus()
            
            bind()
        }
        
        func bind() {
            cancelBag.collect {
                appState.map(\.tab.campus)
                    .removeDuplicates()
                    .dropFirst()
                    .sink {
                        self.selectedCampus = $0
                        self.filterCafeteria()
                        self.fetch()
                    }
                
                appState.map(\.tab.weekComponent)
                    .removeDuplicates()
                    .sink {
                        self.selectedWeekComponent = $0
                        self.filterResponse()
                    }
                
                appState.map(\.userData.bookmark)
                    .removeDuplicates()
                    .sink {
                        self.bookmark = $0
                        self.filterCafeteria()
                    }
                
                appState.map(\.routing.mainViewRouting.settingSheet)
                    .removeDuplicates()
                    .assign(to: \.routingState.settingSheet, on: self)
                
                appState.map(\.cafeteria.menus)
                    .removeDuplicates()
                    .receive(on: DispatchQueue.main)
                    .sink {
                        self.cafeteriaMenus = $0
                        self.filterResponse()
                    }
                
                $routingState
                    .removeDuplicates()
                    .sink {
                        self.appState[\.routing.mainViewRouting] = $0
                    }
            }
        }
        
        // MARK: functions
        func loadDefaultCampus() {
            let defaultCampus = useCases.defaultCampus.load.execute()
            
            appState[\.tab.campus] = defaultCampus
            appState[\.userData.defaultCampus] = defaultCampus
        }
        
        func loadBookmark() {
            let bookmark = useCases.bookmark.load.execute()
            
            appState[\.userData.bookmark] = bookmark
        }
        
        func fetch() {
            let campus = selectedCampus
            appState[\.cafeteria.menus].setIsLoading()
            appState[\.cafeteria.filterByDay] = []
            
            let cachedMenus = useCases.cafeteria.load.execute(campus: campus)
            if let cachedMenus = cachedMenus, cachedMenus.allSatisfy({ $0.isValid(campus) }) {
                appState[\.cafeteria.menus] = .loaded(cachedMenus)
            }
            
            Task {
                do {
                    let cafeteriaMenus = try await useCases.cafeteria.fetch.execute(campus: campus)
                    let currentCampus = self.selectedCampus
                    
                    if cachedMenus != cafeteriaMenus, campus == currentCampus {
                        appState[\.cafeteria.menus] = .loaded(cafeteriaMenus)
                        useCases.cafeteria.save.execute(campus: currentCampus, menus: cafeteriaMenus)
                    }
                }
                catch let error {
                    appState[\.cafeteria.menus] = .failed(error)
                    Task {
                        let log = "UseCases: [\(container.useCases)]"
                        Logger.shared.send(error: error, log: log)
                    }
                }
            }
        }
        
        func filterCafeteria() {
            appState[\.cafeteria.list] = []
            let cafeteriaList = useCases.cafeteria.order.execute(campus: selectedCampus, bookmark: bookmark)
            appState[\.cafeteria.list] = cafeteriaList
        }
        
        func filterResponse() {
            if case .loaded(let menus) = appState[\.cafeteria.menus] {
                let campus = selectedCampus
                let weekComponent = selectedWeekComponent
                let filterByDay = useCases.cafeteria.filter.execute(menus: menus, campus: campus, weekComponent: weekComponent)
                appState[\.cafeteria.filterByDay] = filterByDay
            }
        }
    }
}
