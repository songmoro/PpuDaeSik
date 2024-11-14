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
    @StateObject private var vm = MainViewModel()
    
    var body: some View {
        ZStack {
            Color.gray100.ignoresSafeArea()
            
            VStack {
                header
                CampusTab(viewModel: .init(container: viewModel.container))
                WeekTab(viewModel: .init(container: viewModel.container))
                
                Divider()
                
                switch vm.cafeteriaResponseArray.isEmpty {
                case true:
                    LoadingView()
                default:
                    CafeteriaView(bookmark: $vm.bookmark, campusCafeteria: vm.filterCafeteria(), filteredCafeteriaResponseArray: vm.filterResponse())
                }
                
                Spacer()
            }
            .frame(width: UIScreen.getWidth(350))
            .sheet(isPresented: $viewModel.routingState.settingSheet) {
                BottomSheet(viewModel: .init(container: viewModel.container))
            }
        }
    }
    
    /// 앱 최상단 로고 및 설정 버튼
    var header: some View {
        HStack {
            ImageComponent.logo(viewModel.routingState.settingSheet)
            TextComponent.mainTitle
            
            Spacer()
            
            Button {
                viewModel.showSettingSheet()
            } label: {
                ImageComponent.setting
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
        
        let container: DIContainer
        
        init(container: DIContainer) {
            self.container = container
            let appState = container.appState
            
            _routingState = .init(initialValue: appState.value.routing.mainViewRouting)
        }
        
        func showSettingSheet() {
            routingState.settingSheet = true
        }
    }
}

#Preview {
    MainView(viewModel: .init(container: .preview))
}
