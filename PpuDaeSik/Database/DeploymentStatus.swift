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
            // TODO: 데이터베이스에선 Update인데 이 타입에선 backup으로 나타냄
        case "Update": .backup
        default: nil
        }
        
        guard let status = status else { return nil }
        self = status
    }
}
