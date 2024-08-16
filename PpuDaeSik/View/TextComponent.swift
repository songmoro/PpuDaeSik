//
//  TextComponent.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/16/24.
//

import SwiftUI

struct TextComponent {
    /// 앱 메인 타이틀
    /// - 뿌대식
    static var mainTitle: some View {
        Text("뿌대식")
            .font(.largeTitle())
            .foregroundColor(.black100)
    }
    
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
    
    /// 식당 이름
    /// - 금정회관 학생 식당, 금정회관 교직원 식당, ...
    static func cafeteriaTitle(_ text: String) -> some View {
        Text(text)
            .font(.headline())
            .foregroundColor(.black100)
    }
    
    /// 카테고리 설명
    /// - 조기, 조식, 중식, 석식
    static func categoryText(_ text: String) -> some View {
        Text(text)
            .font(.body())
            .foregroundColor(.black40)
            .frame(width: UIScreen.getWidth(300), alignment: .leading)
    }
    
    /// 식단 이름
    /// - 천원 아침, 정식, 일품, ...
    /// - 학생 식당만 존재
    static func menuTitle(_ text: String) -> some View {
        Text(text)
            .font(.subhead())
            .foregroundColor(.black100)
            .padding(.bottom, UIScreen.getHeight(2))
    }
    
    /// 식단
    /// - 제공되는 학식
    /// - 백미밥\n순두부찌개...
    static func menuContent(_ text: String) -> some View {
        Text(text)
            .font(.body())
            .foregroundColor(.black100)
            .padding(.bottom, UIScreen.getHeight(2))
    }
}
