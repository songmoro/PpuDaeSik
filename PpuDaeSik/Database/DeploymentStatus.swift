//
//  DeploymentStatus.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

enum DeploymentStatus {
    case done, backup
    
    init?(status: String) {
        let status: DeploymentStatus? = switch status {
        case "Done": .done
        case "Backup": .backup
        default: nil
        }
        
        guard let status = status else { return nil }
        self = status
    }
}
