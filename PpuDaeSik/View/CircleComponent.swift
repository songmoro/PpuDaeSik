//
//  CircleComponent.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/16/24.
//

import SwiftUI

struct CircleComponent {
    static var selectedComponentDot: some View {
        Circle()
            .foregroundColor(.blue100)
            .frame(height: UIScreen.getHeight(5))
    }
    
    static var unselectedComponentDot: some View {
        Circle()
            .foregroundColor(.clear)
            .frame(height: UIScreen.getHeight(5))
    }
}
