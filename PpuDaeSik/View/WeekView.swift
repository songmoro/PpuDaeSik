//
//  WeekView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

struct WeekView: View {
    let namespace: Namespace.ID
    let weekday: [Day: Int]
    let week: [Day: DateComponents]
    @Binding var selectedDay: String
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Day.allCases, id: \.self) { weekday in
                VStack(spacing: 0) {
                    TextComponent.weekdayText(week.day.rawValue)
                    
                    Group {
                        TextComponent.dayText(week.dayComponent.description, week.day == Day.today)
                        
                        switch selectedDay {
                        case weekday.rawValue:
                            CircleComponent.selectedComponentDot
                                .matchedGeometryEffect(id: "weekday", in: namespace)
                        default:
                            CircleComponent.unselectedComponentDot
                        }
                    }
                    .onTapGesture {
                        selectedDay = weekday.rawValue
                    }
                    .animation(.default, value: selectedDay)
                }
                .padding(.trailing)
            }
            .frame(width: UIScreen.getWidth(350 / 7))
        }
        .padding(.bottom, UIScreen.getHeight(2))
    }
}
