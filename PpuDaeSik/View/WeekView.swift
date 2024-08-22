//
//  WeekView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

/// 월-금 일과 요일 탭을 나타내는 뷰
struct WeekView: View {
    let namespace: Namespace.ID
    @Binding var selectedDayComponent: DayComponent
    private let vm = WeekViewModel()
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(vm.weekComponentArray, id: \.dayComponent) { weekComponent in
                VStack(spacing: 0) {
                    TextComponent.weekdayText(weekComponent.dayComponent.rawValue)
                    
                    Group {
                        TextComponent.dayText(weekComponent.dayValue.description, weekComponent.dayComponent == DayComponent.today)
                        
                        switch weekComponent.dayComponent {
                        case selectedDayComponent:
                            CircleComponent.selectedComponentDot
                                .matchedGeometryEffect(id: "weekday", in: namespace)
                        default:
                            CircleComponent.unselectedComponentDot
                        }
                    }
                }
                .onTapGesture {
                    selectedDayComponent = weekComponent.dayComponent
                }
                .disabled(selectedDayComponent == weekComponent.dayComponent)
                .animation(.default, value: selectedDayComponent)
                .padding(.trailing)
            }
            .frame(width: UIScreen.getWidth(350 / 7))
        }
        .padding(.bottom, UIScreen.getHeight(2))
    }
}

fileprivate class WeekViewModel {
    /// 1주
    /// - 일, 월, 화, 수, 목, 금, 토
    /// - n, n+1, ..., n+5, n+6일
    let weekComponentArray: [WeekComponent]
    
    /// 오늘 날짜를 기준으로 이번 주를 계산하고 할당
    init() {
        let calendar = Calendar()
        
        let weekArray = zip(DayComponent.allCases, calendar.interval()).reduce(into: [WeekComponent]()) { partialResult, weekday in
            guard let date = calendar.date(byAdding: .day, value: weekday.1, to: Date()) else { return }
            
            let day = weekday.0
            let dayComponent = calendar.component(.day, from: date)
            
            partialResult += [WeekComponent(dayComponent: day, dayValue: dayComponent)]
        }
        
        guard weekArray.count == 7, weekArray.map({ $0.dayComponent }) == DayComponent.allCases else {
            fatalError()
        }
        
        self.weekComponentArray = weekArray
    }
}
