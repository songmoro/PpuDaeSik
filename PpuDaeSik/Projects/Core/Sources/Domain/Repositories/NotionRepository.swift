//
//  NotionRepository.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

import SwiftUI

public protocol NotionRepository {
    var session: URLSession { get }
    
    func fetch<T: Codable>(_ api: NotionAPIAble) async -> T
    func extractErrorCode(from data: Data) -> String
}

public extension NotionRepository {
    func extractErrorCode(from data: Data) -> String {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let errorCode = json["code"] as? String else {
            return "unknown_error"
        }
        return errorCode
    }
}
