//
//  Ext+Font.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/2/24.
//

import SwiftUI

public extension Font {
    static func setFontSize() -> Double {
        return switch UIScreen.screenHeight {
        case 480.0:
            0.85
        case 568.0, 667.0:
            0.9
        case 736.0:
            0.95
        case 812.0:
            0.98
        case 844.0, 852.0:
            1
        case 896.0, 926.0:
            1.05
        case 932.0:
            1.08
        default:
            1
        }
    }
    
    static func largeTitle() -> Font {
        SharedFontFamily.Pretendard.regular.swiftUIFont(size: 26 * setFontSize())
    }
    
    static func title() -> Font {
        SharedFontFamily.Pretendard.regular.swiftUIFont(size: 22 * setFontSize())
    }
    
    static func headline() -> Font {
        SharedFontFamily.Pretendard.regular.swiftUIFont(size: 20 * setFontSize())
    }
    
    static func subhead() -> Font {
        SharedFontFamily.Pretendard.regular.swiftUIFont(size: 19 * setFontSize())
    }
    
    static func body() -> Font {
        SharedFontFamily.Pretendard.regular.swiftUIFont(size: 17 * setFontSize())
    }
}
