//
//  NotionResponse 2.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct NotionResponse<T: Codable>: Codable {
    public let results: [Result<T>]
}
