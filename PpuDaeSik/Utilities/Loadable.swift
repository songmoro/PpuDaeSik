//
//  Loadable.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

import Foundation

enum Loadable<T> {
    case notRequested
    case isLoading(previous: T?, cancelBag: CancelBag)
    case loaded(T)
    case failed(Error)

    var value: T? {
        switch self {
        case let .isLoading(prev, _): return prev
        case let .loaded(value): return value
        default: return nil
        }
    }
}

extension Loadable {
    mutating func setIsLoading(cancelBag: CancelBag) {
        self = .isLoading(previous: self.value, cancelBag: cancelBag)
    }
}
