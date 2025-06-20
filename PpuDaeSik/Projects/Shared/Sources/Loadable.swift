//
//  Loadable.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

import Foundation

public enum Loadable<T> {
    case notRequested
    case isLoading
    case loaded(T)
    case failed(Error)

    public var value: T? {
        switch self {
        case let .loaded(value): return value
        default: return nil
        }
    }
}

public extension Loadable {
    mutating func setIsLoading() {
        self = .isLoading
    }
}

extension Loadable: Equatable where T: Equatable {
    public static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        switch (lhs, rhs) {
        case (.notRequested, .notRequested): return true
        case (.isLoading, .isLoading): return true
        case let (.loaded(lhsV), .loaded(rhsV)): return lhsV == rhsV
        case let (.failed(lhsE), .failed(rhsE)):
            return lhsE.localizedDescription == rhsE.localizedDescription
        default: return false
        }
    }
}
