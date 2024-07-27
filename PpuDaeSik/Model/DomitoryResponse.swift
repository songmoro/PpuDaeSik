//
//  DomitoryResponse.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

struct DomitoryResponse: Codable, Serializable {
    init(_ unwrappedValue: [String: String]) {
        self.no = unwrappedValue["no"] ?? ""
        self.mealDate = unwrappedValue["mealDate"] ?? ""
        self.mealKindGcd = unwrappedValue["mealKindGcd"] ?? ""
        self.codeNm = unwrappedValue["codeNm"] ?? ""
        self.mealNm = unwrappedValue["mealNm"] ?? ""
        
        self.campus = switch self.no {
        case "2", "11", "13": .부산
        case "3": .밀양
        case "12": .양산
        default: .부산
        }
        self.domitory = Domitory(rawValue: Int(self.no)!)!
        self.category = switch self.mealKindGcd {
        case "01": .조기
        case "02": .조식
        case "03": .중식
        case "04": .석식
        default: .조기
        }
    }
    
    init(_ no: String, _ mealDate: String, _ mealKindGcd: String, _ codeNm: String, _ mealNm: String, _ campus: Campus, _ domitory: Domitory, _ category: Category) {
        self.no = no
        self.mealDate = mealDate
        self.mealKindGcd = mealKindGcd
        self.codeNm = codeNm
        self.mealNm = mealNm
        self.campus = campus
        self.domitory = domitory
        self.category = category
    }
    
    init?(_ properties: Properties) {
        let properties = properties.toDict()
        
        guard let no = properties["no"],
              let mealDate = properties["mealDate"],
              let mealKindGcd = properties["mealKindGcd"],
              let codeNm = properties["codeNm"],
              let mealNm = properties["mealNm"]
        else { return nil }
        
        self.init(
            no, mealDate, mealKindGcd, codeNm, mealNm,
            Campus.getCampus(no: no),
            Domitory.getDomitory(no),
            Category.getCategory(mealKindGcd: mealKindGcd)
        )
    }
    
    var uuid = UUID()
    var no: String
    var mealDate: String
    var mealKindGcd: String
    var codeNm: String
    var mealNm: String
    var campus: Campus
    var domitory: Domitory
    var category: Category
}
