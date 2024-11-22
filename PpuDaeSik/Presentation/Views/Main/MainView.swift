//
//  MainView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/2/24.
//

import SwiftUI

struct MainView: View {
    @Namespace private var namespace
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        content
    }
    
    @ViewBuilder var content: some View {
        ZStack {
            Color.gray100.ignoresSafeArea()
            
            VStack {
                MainViewHeader(viewModel: .init(container: viewModel.container))
                CampusTab(viewModel: .init(container: viewModel.container))
                WeekTab(viewModel: .init(container: viewModel.container))
                
                Divider()
                
                switch viewModel.cafeteriaResponse.isEmpty {
                case true:
                    LoadingView()
                default:
                    CafeteriaView(viewModel: .init(container: viewModel.container,
                                                   campusCafeteria: viewModel.filterCafeteria(),
                                                   filteredCafeteriaResponseArray: viewModel.filterResponse())
                                  )
                }
                
                Spacer()
            }
            .frame(width: UIScreen.getWidth(350))
            .sheet(isPresented: $viewModel.routingState.settingSheet) {
                BottomSheet(viewModel: .init(container: viewModel.container))
            }
        }
    }
}

extension MainView {
    struct Routing: Equatable {
        var settingSheet = false
    }
}

extension MainView {
    class ViewModel: ObservableObject {
        @Published var routingState: Routing
        
        /// 현재 선택된 요일
        @Published var selectedWeekComponent: WeekComponent? = .today
        /// 네트워크 요청을 통해 받은 응답 목록
        @Published var cafeteriaResponse: [CafeteriaResponse]
        /// 선택한 캠퍼스
        @Published var selectedCampus: Campus
        /// 사용자가 설정한 앱 시작 시 먼저 보여줄 식당 목록
        @Published var bookmark: [Cafeteria]
        
        let container: DIContainer
        let cancelBag = CancelBag()
        
        init(container: DIContainer) {
            self.container = container
            let appState = container.appState
            
            self._routingState = .init(initialValue: appState.value.routing.mainViewRouting)
            self._bookmark = .init(initialValue: appState.value.userData.bookmark)
            self._selectedCampus = .init(initialValue: appState.value.tab.campus)
            self._cafeteriaResponse = .init(initialValue: appState.value.cafeteria.response)
            
            loadDefaultCampus()
            loadBookmark()
            fetch()
            
            bind()
        }
        
        func bind() {
            let appState = container.appState
            let services = container.services
            
            cancelBag.collect {
                appState.map(\.tab.campus)
                    .removeDuplicates()
                    .handleEvents(receiveOutput: { _ in
                        services
                            .cafeteriaService.fetch()
                    })
                    .assign(to: \.selectedCampus, on: self)
                
                appState.map(\.tab.weekComponent)
                    .removeDuplicates()
                    .assign(to: \.selectedWeekComponent, on: self)
                
                appState.map(\.userData.bookmark)
                    .removeDuplicates()
                    .assign(to: \.bookmark, on: self)
                
                appState.map(\.routing.mainViewRouting.settingSheet)
                    .removeDuplicates()
                    .assign(to: \.routingState.settingSheet, on: self)
                
                appState.map(\.cafeteria.response)
                    .removeDuplicates()
                    .assign(to: \.cafeteriaResponse, on: self)
                
                $routingState
                    .removeDuplicates()
                    .sink {
                        appState[keyPath: \.value.routing.mainViewRouting] = $0
                    }
            }
        }
        
        // MARK: functions
        func loadDefaultCampus() {
            container.services
                .defaultCampusService.loadDefaultCampus()
        }
        
        func loadBookmark() {
            container.services
                .bookmarkService.loadBookmark()
        }
        
        /// 현재 선택된 캠퍼스에 맞는 응답 목록을 담는 함수
        func filterResponse() -> [CafeteriaResponse] {
            self.cafeteriaResponse.filter { response in
                guard let last = response.date.split(separator: "-").last,
                      let dayValue = Int(last),
                      self.selectedWeekComponent?.dayValue == dayValue,
                      response.cafeteria.campus == self.selectedCampus
                else { return false }
                return true
            }
        }
        
        /// 현재 선택된 캠퍼스에 있는 식당을 반환하는 함수
        func filterCafeteria() -> [Cafeteria] {
            let bookmarkedCafeteria = Cafeteria.allCases.filter({ bookmark.contains($0) && $0.campus == selectedCampus })
            let unbookmarkedCafeteria = Cafeteria.allCases.filter({ !bookmark.contains($0) && $0.campus == selectedCampus })
            
            return bookmarkedCafeteria + unbookmarkedCafeteria
        }
        
        func fetch() {
            container.services
                .cafeteriaService.fetch()
        }
    }
}

#Preview {
    MainView(viewModel: .init(container: .preview))
}
