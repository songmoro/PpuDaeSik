//
//  RichText.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct RichText: Codable {
    public let plainText: String
    
    enum CodingKeys: String, CodingKey {
        case plainText = "plain_text"
    }
}
