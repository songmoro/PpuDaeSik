//
//  DeploymentStatus.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

enum DeploymentStatus {
    case done, backup
}

extension DeploymentStatus {
    static func getStatus(_ status: String) -> Self {
        switch status {
        case "Done": .done
        case "Backup": .backup
        default: .backup
        }
    }
}
