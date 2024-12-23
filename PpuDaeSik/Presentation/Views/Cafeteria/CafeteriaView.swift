//
//  CafeteriaView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

/// 각 식당에 대한 뷰
struct CafeteriaView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        content
    }
    
    @ViewBuilder var content: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(viewModel.cafeteria, id: \.self) { cafeteria in
                    VStack {
                        CafeteriaHeader(viewModel: .init(container: viewModel.container, cafeteria: cafeteria))
                        MenuCell(responseArray: viewModel.transform(by: cafeteria))
                    }
                    .id(cafeteria)
                    .padding(.bottom)
                    .padding(.horizontal)
                }
            }
            .onChange(of: viewModel.bookmark) { _, _ in
                guard let first = viewModel.cafeteria.first else { return }
                
                withAnimation {
                    proxy.scrollTo(first, anchor: .top)
                }
            }
        }
    }
}

extension CafeteriaView {
    class ViewModel: ObservableObject {
        @Published var bookmark: [Cafeteria]
        @Published var filterdCafeteriaResponseArray: [CafeteriaResponse]
        let cafeteria: [Cafeteria]
        
        let container: DIContainer
        let cancelBag = CancelBag()
        
        init(container: DIContainer) {
            self.container = container
            let appState = container.appState
            
            self._bookmark = .init(initialValue: appState.value.userData.bookmark)
            self._filterdCafeteriaResponseArray = .init(initialValue: appState.value.cafeteria.filterByDay)
            
            self.cafeteria = appState[\.cafeteria.list]
            
            bind()
        }
        
        func bind() {
            let appState = container.appState
            
            cancelBag.collect {
                appState.map(\.cafeteria.filterByDay)
                    .removeDuplicates()
                    .assign(to: \.filterdCafeteriaResponseArray, on: self)
                
                appState.map(\.userData.bookmark)
                    .removeDuplicates()
                    .assign(to: \.bookmark, on: self)
            }
        }
        
        // MARK: functions
        func transform(by cafeteria: Cafeteria) -> [Category: [CafeteriaResponse]] {
            var dict: [Category: [CafeteriaResponse]] = [:]
            
            let sorted = filterdCafeteriaResponseArray.sorted(by: { $0.category < $1.category })
            
            sorted.forEach {
                if $0.cafeteria == cafeteria {
                    dict[$0.category, default: []].append($0)
                }
            }
            
            return dict
        }
    }
}
