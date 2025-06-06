//
//  Property.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct Property: Codable {
    public let richText: [RichText]
    
    enum CodingKeys: String, CodingKey {
        case richText = "rich_text"
    }
}
