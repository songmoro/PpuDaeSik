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
                WeekView(namespace: namespace, weekday: vm.weekday, week: vm.week, selectedDay: $vm.selectedDay)
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
    
    private var menu: some View {
        ScrollView {
            ForEach(vm.sortedByBookmark(), id: \.self) { sorted in
                VStack {
                    let filtered = vm.cafeteriaResponseArray.filter { response in
                        guard let last = response.date.split(separator: "-").last,
                              let day = Int(last),
                              let selectedWeekday = Day(rawValue: vm.selectedDay),
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
