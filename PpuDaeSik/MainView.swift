//
//  MainView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/2/24.
//

import SwiftUI

struct MainView: View {
    @Namespace private var namespace
    @StateObject private var vm = MainViewModel()
    
    var body: some View {
        ZStack {
            Color.gray100.ignoresSafeArea()
            
            VStack {
                HeaderView(isSheetShow: $vm.isSheetShow)
                CampusView(namespace: namespace, selectedCampus: $vm.selectedCampus)
                week
                Divider()
                menu
                Spacer()
            }
            .frame(width: UIScreen.getWidth(350))
            .sheet(isPresented: $vm.isSheetShow) {
                Sheet(defaultCampus: $vm.defaultCampus)
            }
        }
    }
    
    private var week: some View {
        HStack(spacing: 0) {
            ForEach(Week.allCases, id: \.self) { weekday in
                VStack(spacing: 0) {
                    TextComponent.weekdayText(weekday.rawValue)
                    
                    Group {
                        if let day = vm.week[weekday]?.day {
                            TextComponent.dayText(day.description, weekday.rawValue == Week.allCases[Calendar.current.component(.weekday, from: Date()) - 1].rawValue)
                        }
                        
                        if weekday.rawValue == vm.selectedDay  {
                            CircleComponent.selectedComponentDot
                                .matchedGeometryEffect(id: "weekday", in: namespace)
                        }
                        else {
                            CircleComponent.unselectedComponentDot
                        }
                    }
                    .onTapGesture {
                        vm.selectedDay = weekday.rawValue
                    }
                    .animation(.default, value: vm.selectedDay)
                }
                .padding(.trailing)
            }
            .frame(width: UIScreen.getWidth(350 / 7))
        }
        .padding(.bottom, UIScreen.getHeight(2))
    }
    
    private var menu: some View {
        ScrollView {
            ForEach(vm.sortedByBookmark(), id: \.self) { sorted in
                VStack {
                    let filtered = vm.cafeteriaResponseArray.filter { response in
                        guard let last = response.date.split(separator: "-").last,
                              let day = Int(last),
                              let selectedWeekday = Week(rawValue: vm.selectedDay),
                              let selectedDay = vm.week[selectedWeekday]?.day
                        else { return false }
                        
                        return response.cafeteria.name == sorted && day == selectedDay
                    }
                    
                    MenuView(bookmark: $vm.bookmark, name: sorted, responseArray: filtered)
                        .padding(.bottom)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
