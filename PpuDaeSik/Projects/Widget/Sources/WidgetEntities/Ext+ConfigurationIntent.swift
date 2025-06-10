//
//  Ext+ConfigurationIntent.swift
//  Widget
//
//  Created by 송재훈 on 6/10/25.
//

import Foundation
import Entities

extension ConfigurationIntent {
    func getCafeteria() -> Cafeteria? {
        switch self.RestaurantEnum {
        case .d001: .진리관
        case .d002: .웅비관
        case .d003: .자유관
        case .d004: .비마관
        case .d005: .행림관
        case .g001: .금정회관교직원식당
        case .g002: .금정회관학생식당
        case .h001: .학생회관학생식당
        case .m001: .학생회관밀양교직원식당
        case .m002: .학생회관밀양학생식당
        case .s001: .샛벌회관식당
        case .y001: .편의동2층양산식당
        case .unknown: nil
        }
    }
    
    func getCategory() -> String? {
        let hour = Calendar.current.component(.hour, from: Date())
        
        return switch self.RestaurantEnum {
        case .d001, .d002, .d003, .d004, .d005:
            switch hour {
            case 20...23: "01"
            case 0...8: "02"
            case 9...13: "03"
            case 14...19: "04"
            default: nil
            }
        case .g002, .y001:
            switch hour {
            case 20...23: "B"
            case 0...8: "B"
            case 9...13: "L"
            case 14...19: "D"
            default: nil
            }
        case .g001, .h001, .s001, .m001, .m002:
            switch hour {
            case 0...14: "L"
            case 15...19: "D"
            case 20...23: "L"
            default: nil
            }
        case .unknown: nil
        }
    }
}
