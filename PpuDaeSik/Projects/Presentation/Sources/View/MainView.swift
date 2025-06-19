//
//  MainView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/2/24.
//

import SwiftUI
import Shared

public struct MainView: View {
    @Namespace private var namespace
    @ObservedObject private(set) var viewModel: MainView.ViewModel
    
    public init(viewModel: MainView.ViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
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
        switch viewModel.cafeteriaMenus {
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
            ReloadView(onRetry: viewModel.fetch)
                .onAppear {
                    print(error.localizedDescription)
                }
        }
    }
}

#Preview {
    MainView(viewModel: .init(container: .preview))
}
