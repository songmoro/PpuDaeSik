//
//  CheckDatabase.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

struct CheckDatabase: Codable {
    var results: [CheckProperties]
    
    struct CheckProperties: Codable {
        var properties: [String: CheckProperty]
        
        struct CheckProperty: Codable {
            var type: String
            var title: [RichText]?
            var rich_text: [RichText]?
            
            struct RichText: Codable {
                var plain_text: String
            }
        }
    }
}
