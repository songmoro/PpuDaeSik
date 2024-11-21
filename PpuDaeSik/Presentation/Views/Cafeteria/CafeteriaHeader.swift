//
//  CafeteriaHeader.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

/// 식당 이름과 북마크를 설정할 수 있는 뷰
struct CafeteriaHeader: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.cafeteria.name)
                .font(.headline())
                .foregroundColor(.black100)
            
            Spacer()
            
            Button {
                viewModel.bookmarkAction()
            } label: {
                Image(systemName: "star.fill")
                    .font(.headline())
                    .foregroundColor(viewModel.isBookmarked() ? .yellow100 : .black20)
            }
        }
        .padding(.bottom, UIScreen.getHeight(2))
    }
}

extension CafeteriaHeader {
    class ViewModel: ObservableObject {
        @Binding var bookmark: [Cafeteria]
        let cafeteria: Cafeteria
        
        let container: DIContainer
        
        init(container: DIContainer, bookmark: Binding<[Cafeteria]>, cafeteria: Cafeteria) {
            self.container = container
            
            self._bookmark = bookmark
            self.cafeteria = cafeteria
        }
        
        func isBookmarked() -> Bool {
            bookmark.contains(cafeteria)
        }
        
        func bookmarkAction() {
            if bookmark.contains(cafeteria) {
                bookmark.removeAll {
                    $0 == cafeteria
                }
            }
            else {
                bookmark.append(cafeteria)
            }
        }
    }
}
