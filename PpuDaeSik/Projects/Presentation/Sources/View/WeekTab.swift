//
//  WeekTab.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/13/24.
//

import SwiftUI
import Shared

/// 월-금 일과 요일 탭을 나타내는 뷰
struct WeekTab: View {
    @Namespace var namespace
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.weekComponentArray, id: \.dayComponent) { weekComponent in
                let isSelected = viewModel.isSelected(weekComponent)
                let isToday = viewModel.isToday(weekComponent)
                
                Button {
                    viewModel.changeSelectedWeekComponent(to: weekComponent)
                } label: {
                    VStack(spacing: 0) {
                        Text(weekComponent.dayComponent.rawValue)
                            .foregroundColor(.black100)
                            .font(.body())
                        Text(weekComponent.dayValue.description)
                            .foregroundColor(isToday ? .black100 : .black40)
                            .font(.headline())
                            .padding(.bottom, UIScreen.getHeight(6))
                        
                        if isSelected {
                            Circle()
                                .foregroundColor(.blue100)
                                .frame(height: UIScreen.getHeight(5))
                                .matchedGeometryEffect(id: "weekday", in: namespace)
                        }
                        else {
                            Circle()
                                .foregroundColor(.clear)
                                .frame(height: UIScreen.getHeight(5))
                        }
                    }
                }
                .disabled(isSelected)
                .padding(.trailing)
            }
            .frame(width: UIScreen.getWidth(350 / 7))
        }
        .animation(.default, value: viewModel.selectedWeekComponent)
        .padding(.bottom, UIScreen.getHeight(2))
    }
}
