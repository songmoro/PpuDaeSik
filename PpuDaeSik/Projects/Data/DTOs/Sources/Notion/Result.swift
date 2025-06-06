//
//  Result.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct Result<T: Codable>: Codable {
    public let properties: T
}
