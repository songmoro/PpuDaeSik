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
                WeekView(namespace: namespace, weekArray: vm.weekArray, selectedDay: $vm.selectedDay)
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
                              let week = vm.weekArray.filter({ $0.dayComponent == day }).first,
                              week.day == vm.selectedDay,
                              response.cafeteria.name == sorted
                        else { return false }
                        
                        return true
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
