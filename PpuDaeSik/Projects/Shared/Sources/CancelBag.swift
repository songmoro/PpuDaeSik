//
//  CancelBag.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

import Foundation
import Combine

public final class CancelBag {
    fileprivate(set) var subscriptions = Set<AnyCancellable>()
    
    func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        subscriptions.formUnion(cancellables())
    }
    
    func cancel() {
        subscriptions.removeAll()
    }
    
    @resultBuilder
    struct Builder {
        static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            return cancellables
        }
    }
}

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
