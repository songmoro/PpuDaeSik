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
        ZStack {
            Color.gray100.ignoresSafeArea()
            
            VStack {
                header
                Divider()
                
                content
                
                Spacer()
            }
            .frame(width: UIScreen.getWidth(350))
            .sheet(isPresented: $viewModel.routingState.settingSheet) {
                BottomSheet(viewModel: .init(container: viewModel.container))
            }
        }
    }
    
    @ViewBuilder var header: some View {
        MainViewHeader(viewModel: .init(container: viewModel.container))
        CampusTab(viewModel: .init(container: viewModel.container))
        WeekTab(viewModel: .init(container: viewModel.container))
    }
    
    @ViewBuilder var content: some View {
        switch viewModel.cafeteriaResponse {
        case .notRequested:
            Text("")
                .onAppear {
                    viewModel.filterCafeteria()
                    viewModel.fetch()
                }
        case .isLoading:
            LoadingView()
        case .loaded:
            CafeteriaView(viewModel: .init(container: viewModel.container))
        case .failed(let error):
            Text(error.localizedDescription)
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
        @Published var selectedWeekComponent: WeekComponent = .getToday()
        /// 네트워크 요청을 통해 받은 응답 목록
        @Published var cafeteriaResponse: Loadable<[CafeteriaResponse]>
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
            
            bind()
        }
        
        func bind() {
            let appState = container.appState
            
            cancelBag.collect {
                appState.map(\.tab.campus)
                    .removeDuplicates()
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
                
                appState.map(\.cafeteria.response)
                    .removeDuplicates()
                    .sink {
                        self.cafeteriaResponse = $0
                        self.filterResponse()
                    }
                
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
        
        func fetch() {
            let appState = container.appState
            let cafeteriaUseCases = container.useCases.cafeteria
            let campus = appState[\.tab.campus]
            
            cafeteriaUseCases.update.execute(input: .init(response: .isLoading, filterByDay: []))
            let cachedResponse = cafeteriaUseCases.load.execute(campus: selectedCampus)
            if let cachedResponse = cachedResponse, cachedResponse.first?.cafeteria.campus == campus {
                cafeteriaUseCases.update.execute(input: .init(response: .loaded(cachedResponse)))
            }
            
            Task {
                cafeteriaUseCases.cancleAll.execute()
                
                async let restaurantDeployment = await cafeteriaUseCases.checkDeployment.execute(for: .restaurant)
                async let dormitoryDeployment = await cafeteriaUseCases.checkDeployment.execute(for: .dormitory)
                
                let (restaurantIsUpdating, dormitoryIsUpdating) = (await restaurantDeployment, await dormitoryDeployment)
                
                async let restaurantResponse = await cafeteriaUseCases.fetch.execute(isUpdating: restaurantIsUpdating, campus: campus, for: .restaurant)
                async let dormitoryResponse = await cafeteriaUseCases.fetch.execute(isUpdating: dormitoryIsUpdating, campus: campus, for: .dormitory)

                let newCafeteriaResponse = await restaurantResponse + dormitoryResponse
                
                let responseCampus = appState[\.tab.campus]
                if cachedResponse != newCafeteriaResponse, campus == responseCampus {
                    DispatchQueue.main.async {
                        cafeteriaUseCases.update.execute(input: .init(response: .loaded(newCafeteriaResponse)))
                    }
                    
                    cafeteriaUseCases.save.execute(campus: responseCampus, response: newCafeteriaResponse)
                }
            }
        }
        
        func filterCafeteria() {
            let cafeteriaUseCases = container.useCases.cafeteria
            
            cafeteriaUseCases.update.execute(input: .init(list: []))
            
            let newCafeteriaList = cafeteriaUseCases.order.execute(campus: selectedCampus, bookmark: bookmark)
            cafeteriaUseCases.update.execute(input: .init(list: newCafeteriaList))
        }
        
        func filterResponse() {
            let cafeteriaUseCases = container.useCases.cafeteria
            let appState = container.appState
            let response = appState[\.cafeteria.response]
            let campus = appState[\.tab.campus]
            let weekComponent = appState[\.tab.weekComponent]
            
            let newFilterByDay = cafeteriaUseCases.filter.execute(response: response, campus: campus, weekComponent: weekComponent)
            cafeteriaUseCases.update.execute(input: .init(filterByDay: newFilterByDay))
        }
    }
}

#Preview {
    MainView(viewModel: .init(container: .preview))
}
