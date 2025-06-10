//
//  WidgetRepository.swift
//  Widget
//
//  Created by 송재훈 on 6/10/25.
//

import Foundation
import Entities

public protocol WidgetRepository {
    func fetch(cafeteria: Cafeteria, category: String) async -> CafeteriaMenu?
}
