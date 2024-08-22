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
                WeekView(namespace: namespace, selectedWeekComponent: $vm.selectedWeekComponent)
                Divider()
                
                switch vm.onFetchCount {
                case 0:
                    CafeteriaView(bookmark: $vm.bookmark, campusCafeteria: vm.filterCafeteria(), responseArray: vm.filteredCafeteriaResponseArray)
                default:
                    LoadingView()
                }
                
                Spacer()
            }
            .frame(width: UIScreen.getWidth(350))
            .sheet(isPresented: $vm.isSheetShow) {
                Sheet(defaultCampus: $vm.defaultCampus)
            }
        }
    }
}

#Preview {
    MainView()
}
