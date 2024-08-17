//
//  WeekView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

// 월-금 일과 요일 탭을 나타내는 뷰
struct WeekView: View {
    let namespace: Namespace.ID
    let weekArray: [Week]
    @Binding var selectedDay: Day
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(weekArray, id: \.day) { weekday in
                VStack(spacing: 0) {
                    TextComponent.weekdayText(weekday.day.rawValue)
                    
                    Group {
                        TextComponent.dayText(weekday.dayComponent.description, weekday.day == Day.today)
                        
                        switch weekday.day {
                        case selectedDay:
                            CircleComponent.selectedComponentDot
                                .matchedGeometryEffect(id: "weekday", in: namespace)
                        default:
                            CircleComponent.unselectedComponentDot
                        }
                    }
                }
                .onTapGesture {
                    selectedDay = weekday.day
                }
                .animation(.default, value: selectedDay)
                .padding(.trailing)
            }
            .frame(width: UIScreen.getWidth(350 / 7))
        }
        .padding(.bottom, UIScreen.getHeight(2))
    }
}
