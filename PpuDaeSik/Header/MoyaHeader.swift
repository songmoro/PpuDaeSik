//
//  MoyaHeader.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/12/24.
//

import SwiftUI

enum MoyaHeader {
    case Notion
    
    func header() -> [String: String] {
        ["Content-Type": "application/json", "Notion-Version": "2022-02-22", "Authorization": "Bearer secret_pjqPKFig0CIkvnm5BwFC8NWueGnV7MuXOYM0qXJeOzr"]
    }
}
