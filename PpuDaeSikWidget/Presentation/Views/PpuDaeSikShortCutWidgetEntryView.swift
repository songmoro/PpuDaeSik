//
//  PpuDaeSikShortCutWidgetEntryView.swift
//  PpuDaeSikWidgetExtension
//
//  Created by 송재훈 on 11/25/24.
//

import SwiftUI

struct PpuDaeSikShortCutWidgetEntryView : View {
    var entry: ShortCutEntry
    
    var body: some View {
        ZStack {
            Color.blue100.ignoresSafeArea()
            
            Image("Logo")
                .resizable()
                .frame(width: 60, height: 60)
        }
    }
}
