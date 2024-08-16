//
//  MainView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/2/24.
//

import SwiftUI

struct MainView: View {
    @Namespace private var namespcae
    @StateObject private var vm = MainViewModel()
    
    var body: some View {
        ZStack {
            Color.gray100.ignoresSafeArea()
            
            VStack {
                title
                campus
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
    
    private var title: some View {
        HStack {
            Image(vm.isSheetShow ? "LogoEye" : "Logo")
                .resizable()
                .frame(width: UIScreen.getWidth(50), height: UIScreen.getWidth(50))
            
            TextComponent.mainTitle
            
            Spacer()
            
            Button {
                vm.isSheetShow = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.largeTitle())
                    .foregroundColor(.blue100)
            }
        }
    }
    
    private var campus: some View {
        HStack(spacing: 0) {
            ForEach(Campus.allCases, id: \.self) { campus in
                VStack(spacing: 0) {
                    TextComponent.campusTitle(campus.rawValue, campus == vm.selectedCampus)
                    
                    if campus == vm.selectedCampus {
                        Circle()
                            .foregroundColor(.blue100)
                            .frame(height: UIScreen.getHeight(5))
                            .matchedGeometryEffect(id: "campus", in: namespcae)
                    }
                    else {
                        Circle()
                            .foregroundColor(.clear)
                            .frame(height: UIScreen.getHeight(5))
                    }
                }
                .onTapGesture {
                    vm.selectedCampus = campus
                }
                .animation(.default, value: vm.selectedCampus)
                .padding(.trailing)
            }
            .font(.title())
            
            Spacer()
        }
        .padding(.bottom, UIScreen.getHeight(8))
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
                            Circle()
                                .foregroundColor(.blue100)
                                .frame(height: UIScreen.getHeight(5))
                                .matchedGeometryEffect(id: "weekday", in: namespcae)
                        }
                        else {
                            Circle()
                                .foregroundColor(.clear)
                                .frame(height: UIScreen.getHeight(5))
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
