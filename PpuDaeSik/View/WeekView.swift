//
//  WeekView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

struct WeekView: View {
    let namespace: Namespace.ID
    let weekday: [Week: Int]
    let week: [Week: DateComponents]
    @Binding var selectedDay: String
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Week.allCases, id: \.self) { weekday in
                VStack(spacing: 0) {
                    TextComponent.weekdayText(weekday.rawValue)
                    
                    Group {
                        if let day = week[weekday]?.day {
                            TextComponent.dayText(day.description, weekday.rawValue == Week.allCases[Calendar.current.component(.weekday, from: Date()) - 1].rawValue)
                        }
                        
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
