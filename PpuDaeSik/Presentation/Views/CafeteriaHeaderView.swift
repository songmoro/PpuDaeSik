//
//  CafeteriaHeaderView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

/// 식당 이름과 북마크를 설정할 수 있는 뷰
struct CafeteriaHeaderView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            TextComponent.cafeteriaTitle(viewModel.cafeteria.name)
            
            Spacer()
            
            ImageComponent.star(viewModel.bookmark.contains(viewModel.cafeteria))
                .onTapGesture {
                    if viewModel.bookmark.contains(viewModel.cafeteria) {
                        viewModel.bookmark.removeAll {
                            $0 == viewModel.cafeteria
                        }
                    }
                    else {
                        viewModel.bookmark.append(viewModel.cafeteria)
                    }
                }
        }
        .padding(.bottom, UIScreen.getHeight(2))
    }
}

extension CafeteriaHeaderView {
    class ViewModel: ObservableObject {
        @Binding var bookmark: [Cafeteria]
        let cafeteria: Cafeteria
        
        let container: DIContainer
        let cancelBag = CancelBag()
        
        init(container: DIContainer, bookmark: Binding<[Cafeteria]>, cafeteria: Cafeteria) {
            self.container = container
            
            self._bookmark = bookmark
            self.cafeteria = cafeteria
        }
    }
}
