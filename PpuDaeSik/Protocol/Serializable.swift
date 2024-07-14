//
//  Serializable.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

protocol Serializable {
    init(_ unwrappedValue: [String: String])
    init?(_ properties: Properties)
}
