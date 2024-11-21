//
//  TextComponent.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/16/24.
//

import SwiftUI

/// 텍스트와 관련된 뷰 요소
struct TextComponent {
    /// 캠퍼스 구분 타이틀
    /// - 부산, 밀양, 양산
    static func campusTitle(_ text: String, _ condition: Bool) -> some View {
        Text(text)
            .foregroundColor(condition ? .black100 : .black40)
            .padding(.bottom, UIScreen.getHeight(6))
    }
    
    /// 요일 텍스트
    /// - 일, 월, 화, 수, 목, 금, 토
    static func weekdayText(_ text: String) -> some View {
        Text(text)
            .foregroundColor(.black100)
            .font(.body())
    }
    
    /// 일 텍스트
    /// - 1, 2, ... , 31
    static func dayText(_ text: String, _ condition: Bool) -> some View {
        Text(text)
            .foregroundColor(condition ? .black100 : .black40)
            .font(.headline())
            .padding(.bottom, UIScreen.getHeight(6))
    }
    
    /// 시트 피커 설명
    /// - 기본 캠퍼스
    static var sheetPickerTitle: some View {
        Text("기본 캠퍼스")
            .foregroundColor(.black100)
    }
    
    /// 시트 피커 요소
    /// - 부산, 밀양, 양산
    static func sheetPickerComponent(_ text: String) -> some View {
        Text(text)
            .tag(text)
    }
}

struct TextComponent_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                TextComponent.campusTitle("부산", true)
                TextComponent.campusTitle("부산", false)
            }
            HStack {
                TextComponent.weekdayText("일")
                TextComponent.weekdayText("월")
                TextComponent.weekdayText("화")
                TextComponent.weekdayText("수")
                TextComponent.weekdayText("목")
                TextComponent.weekdayText("금")
                TextComponent.weekdayText("토")
            }
            HStack {
                TextComponent.dayText("1", true)
                TextComponent.dayText("2", false)
                TextComponent.dayText("3", false)
                TextComponent.dayText("4", false)
                TextComponent.dayText("5", false)
                TextComponent.dayText("6", false)
                TextComponent.dayText("7", false)
            }
            HStack {
                TextComponent.dayText("10", true)
                TextComponent.dayText("11", false)
                TextComponent.dayText("12", false)
                TextComponent.dayText("13", false)
                TextComponent.dayText("14", false)
                TextComponent.dayText("15", false)
                TextComponent.dayText("16", false)
            }
            TextComponent.sheetPickerTitle
            TextComponent.sheetPickerComponent("부산")
        }
    }
}
