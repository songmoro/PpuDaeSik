//
//  NotionDatabase.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

enum NotionDatabase {
    case status
    case restaurant
    case domitory
    case restaurantBackup
    case domitoryBackup
    
    private func id() -> String {
        switch self {
        case .status:
            "233f1075520f4e38b9fb8350901219fb"
        case .restaurant:
            "da22b69d795c4e879b77dd657948ea4e"
        case .domitory:
            "264bceb5a8ef45a0befbec5d407b37f9"
        case .restaurantBackup:
            "912baee21c7643628355569d16aeb8b8"
        case .domitoryBackup:
            "656bc1391c7843e292a7d89be6567f74"
        }
    }
    
    func path() -> String {
        "/databases/" + self.id() + "/query"
    }
}
