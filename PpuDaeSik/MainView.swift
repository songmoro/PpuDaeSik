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
            .onAppear {
                vm.currentWeek()
                vm.selectedDay = Week.allCases[Calendar.current.component(.weekday, from: Date()) - 1].rawValue
                vm.requestCampusDatabase()
            }
            .sheet(isPresented: $vm.isSheetShow) {
                Sheet()
            }
        }
    }
    
    private var title: some View {
        HStack {
            Image(vm.isSheetShow ? "LogoEye" : "Logo")
                .resizable()
                .frame(width: UIScreen.getWidth(50), height: UIScreen.getWidth(50))
            
            Text("뿌대식")
                .font(.largeTitle())
                .foregroundColor(.black100)
            
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
            ForEach(Campus.allCases, id: \.self) { location in
                VStack(spacing: 0) {
                    Text("\(location.rawValue)")
                        .foregroundColor(location.rawValue == vm.selectedCampus ? .black100 : .black40)
                        .padding(.bottom, UIScreen.getHeight(6))
                    
                    if location.rawValue == vm.selectedCampus {
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
                    vm.selectedCampus = location.rawValue
                    vm.requestCampusDatabase()
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
            ForEach(Week.allCases, id: \.self) { day in
                VStack(spacing: 0) {
                    Text("\(day.rawValue)")
                        .foregroundColor(.black100)
                        .font(.body())
                    
                    Group {
                        if let weekdate = vm.weekday[day] {
                            Text("\(weekdate)")
                                .foregroundColor(day.rawValue == Week.allCases[Calendar.current.component(.weekday, from: Date()) - 1].rawValue ? .black100 : .black40)
                                .font(.headline())
                                .padding(.bottom, UIScreen.getHeight(6))
                        }
                        
                        if day.rawValue == vm.selectedDay  {
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
                        vm.selectedDay = day.rawValue
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
            if let selectedWeekday = Week(rawValue: vm.selectedDay) {
                ForEach(Campus(rawValue: vm.selectedCampus)!.restaurant, id: \.rawValue) {
                    if let restaurant = vm.menu[selectedWeekday]![$0] {
                        MenuView(restaurant: $0.rawValue, meal: restaurant)
                    }
                }
            }
        }
    }
    
    private struct MenuView: View {
        @State private var isFavorite = false
        let restaurant: String
        let meal: Meal
        
        var body: some View {
            VStack {
                title
                card
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        
        private var title: some View {
            HStack {
                Text(restaurant)
                    .font(.headline())
                    .foregroundColor(.black100)
                
                Spacer()
                
                Button {
                    isFavorite = true
                } label: {
                    Image(systemName: "star.fill")
                        .font(.headline())
                        .foregroundColor(isFavorite ? .yellow100 : .black20)
                }
            }
        }
        
        private var card: some View {
            VStack(alignment: .leading) {
                ForEach(Category.allCases, id: \.self) {
                    if let food = meal.foodByCategory[$0] {
                        Text("\($0.rawValue)")
                            .font(.subhead())
                            .foregroundColor(.black100)
                            .padding(.bottom, UIScreen.getHeight(2))
                        
                        Text("\(food)")
                            .font(.body())
                            .foregroundColor(.black100)
                            .padding(.bottom, UIScreen.getHeight(18))
                    }
                }
            }
            .padding()
            .frame(width: UIScreen.getWidth(350), alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.white100)
                    .shadow(radius: 2)
            }
        }
    }
}

#Preview {
    MainView()
}
