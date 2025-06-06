////
////  CafeteriaResponse.swift
////  PpuDaeSik
////
////  Created by 송재훈 on 8/14/24.
////
//
//import Foundation
//
///// 기숙사, 학생 식당 응답
//public struct CafeteriaResponse: Hashable {
//    internal init(
//        cafeteria: Cafeteria,
//        date: String,
//        category: Category,
//        title: String? = nil,
//        content: String,
//        breakfastTime: String? = nil,
//        lunchTime: String? = nil,
//        dinnerTime: String? = nil
//    ) {
//        self.cafeteria = cafeteria
//        self.date = date
//        self.category = category
//        self.title = title
//        self.content = content
//        self.breakfastTime = breakfastTime
//        self.lunchTime = lunchTime
//        self.dinnerTime = dinnerTime
//    }
//    
//    var uuid = UUID()
//    /// 기숙사, 학생 식당 기본 정보
//    let cafeteria: Cafeteria
//    /// 식단 날짜
//    let date: String
//    /// 식단 타입(조기, 조식, 중식, 석식)
//    /// 기숙사: 조기, 조식, 중식, 석식
//    /// 학생 식당: 조식, 중식, 석식
//    let category: Category
//    /// 학생 식당 식단 명
//    let title: String?
//    /// 식단
//    let content: String
//    /// 조식 운영시간
//    let breakfastTime: String?
//    /// 중식 운영시간
//    let lunchTime: String?
//    /// 석식 운영시간
//    let dinnerTime: String?
//}
//
//extension CafeteriaResponse: Codable {
//    
//}
//
//extension CafeteriaResponse: Equatable {
//    public static func == (lhs: CafeteriaResponse, rhs: CafeteriaResponse) -> Bool {
//        return lhs.cafeteria == rhs.cafeteria &&
//        lhs.date == rhs.date &&
//        lhs.category == rhs.category &&
//        lhs.title == rhs.title &&
//        lhs.content == rhs.content &&
//        lhs.breakfastTime == rhs.breakfastTime &&
//        lhs.lunchTime == rhs.lunchTime &&
//        lhs.dinnerTime == rhs.dinnerTime
//    }
//}
