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

extension NotionAPIAble {
    public var path: String {
        "/databases/" + self.id + "/query"
    }
    
    public var baseUrl: String {
        "https://api.notion.com/v1"
    }
    
    public var url: URL {
        URL(string: baseUrl + path)!
    }
    
    public var method: String {
        "POST"
    }
    
    public var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "Notion-Version": "2022-02-22",
            "Authorization": "Bearer secret_pjqPKFig0CIkvnm5BwFC8NWueGnV7MuXOYM0qXJeOzr"
        ]
    }
}
