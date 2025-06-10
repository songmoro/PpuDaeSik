//
//  CafeteriaView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI
import Entities
import Shared

/// 각 식당에 대한 뷰
public struct CafeteriaView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    public var body: some View {
        content
    }
    
    @ViewBuilder var content: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(viewModel.cafeteria, id: \.self) { cafeteria in
                    VStack {
                        CafeteriaHeader(viewModel: .init(container: viewModel.container, cafeteria: cafeteria))
                        MenuCell(menus: viewModel.transform(by: cafeteria))
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
