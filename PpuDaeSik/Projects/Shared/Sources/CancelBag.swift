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
    
    public init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.subscriptions = subscriptions
    }
    
    public func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        subscriptions.formUnion(cancellables())
    }
    
    private func cancel() {
        subscriptions.removeAll()
    }
    
    @resultBuilder
    public struct Builder {
        public static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            return cancellables
        }
    }
}

public extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
