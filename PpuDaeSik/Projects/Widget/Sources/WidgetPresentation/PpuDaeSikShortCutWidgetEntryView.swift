//
//  PpuDaeSikShortCutWidgetEntryView.swift
//  PpuDaeSikWidgetExtension
//
//  Created by 송재훈 on 11/25/24.
//

import SwiftUI
import Shared

struct PpuDaeSikShortCutWidgetEntryView : View {
    var entry: ShortCutEntry
    
    var body: some View {
        ZStack {
            Color.blue100.ignoresSafeArea()
            
            //            Image("Logo")
            SharedAsset.logo.swiftUIImage
                .resizable()
                .frame(width: 60, height: 60)
        }
    }
}

#Preview {
    PpuDaeSikShortCutWidgetEntryView(entry: .init(date: Date()))
}
