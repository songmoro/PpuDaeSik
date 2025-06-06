//
//  NotionAPIAble.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

import Foundation

public protocol NotionAPIAble {
    var id: String { get }
    var path: String { get }
    var baseUrl: String { get }
    var url: URL { get }
    var method: String { get }
    var headers: [String: String]? { get }
    func request() -> URLRequest
}
