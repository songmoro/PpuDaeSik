//
//  CafeteriaHeader.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI
import Shared

/// 식당 이름과 북마크를 설정할 수 있는 뷰
struct CafeteriaHeader: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
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
