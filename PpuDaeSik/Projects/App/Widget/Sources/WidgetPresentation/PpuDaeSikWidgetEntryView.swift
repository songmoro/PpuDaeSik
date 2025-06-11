//
//  PpuDaeSikWidgetEntryView.swift
//  PpuDaeSikWidgetExtension
//
//  Created by 송재훈 on 11/25/24.
//

import SwiftUI
import Shared

struct PpuDaeSikWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.gray100.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("\(entry.name)")
                        .bold()
                    
                    Text("\(entry.category)")
                        .foregroundColor(.black40)
                }
                .font(.footnote)
                .padding(.bottom, 4)
                
                HStack {
                    Text(entry.meal)
                        .font(.caption)
                }
            }
            .foregroundColor(.black100)
        }
    }
}
