//
//  NotionRepository.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

import SwiftUI

protocol NotionRepository {
    var session: URLSession { get }
    
    func fetch<T: Codable>(_ api: NotionAPIAble) async -> T
}
