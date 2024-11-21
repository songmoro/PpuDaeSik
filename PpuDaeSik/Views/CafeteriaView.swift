//
//  CafeteriaView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

/// 각 식당에 대한 뷰
struct CafeteriaView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(viewModel.campusCafeteria, id: \.self) { cafeteria in
                    VStack {
                        CafeteriaHeaderView(viewModel: .init(container: viewModel.container, bookmark: $viewModel.bookmark, cafeteria: cafeteria))
                        MealView(viewModel: .init(container: viewModel.container, responseArray: viewModel.filteredCafeteriaResponseArray.filter({ $0.cafeteria == cafeteria })))
                    }
                    .id(cafeteria)
                    .padding(.bottom)
                    .padding(.horizontal)
                }
            }
            .onChange(of: viewModel.bookmark) { _, _ in
                guard let first = viewModel.campusCafeteria.first else { return }
                
                withAnimation {                
                    proxy.scrollTo(first, anchor: .top)
                }
            }
        }
    }
}

extension CafeteriaView {
    class ViewModel: ObservableObject {
        @Binding var bookmark: [Cafeteria]
        let campusCafeteria: [Cafeteria]
        let filteredCafeteriaResponseArray: [CafeteriaResponse]
        
        let container: DIContainer
        let cancelBag = CancelBag()
        
        init(container: DIContainer, bookmark: Binding<[Cafeteria]>, campusCafeteria: [Cafeteria], filteredCafeteriaResponseArray: [CafeteriaResponse]) {
            self.container = container
            
            self._bookmark = bookmark
            self.campusCafeteria = campusCafeteria
            self.filteredCafeteriaResponseArray = filteredCafeteriaResponseArray
        }
    }
}
