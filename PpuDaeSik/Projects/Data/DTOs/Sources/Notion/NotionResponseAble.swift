//
//  NotionResponseAble.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public protocol NotionResponseAble: Codable {
    associatedtype resultType: Codable
    var results: [Result<resultType>] { get }
}
