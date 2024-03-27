//
//  Boolean.swift
//  YuzPay
//
//  Created by applebro on 10/03/23.
//

import Foundation
import Combine

class Boolean {
    @Published var value: Bool = false
    private var cancellables = Set<AnyCancellable>()

    init() {
        $value
            .sink(receiveValue: { [weak self] newValue in
                self?.onChange?(newValue)
            })
            .store(in: &cancellables)
            
    }
    
    var onChange: ((Bool) -> Void)?
    
    func cancel() {
        cancellables.forEach { c in
            c.cancel()
        }
    }
    
    deinit {
        print("Destroy boolean object")
    }
}

class DebouncedString: ObservableObject {
    @Published var value: String
    @Published var debouncedValue: String
    
    private var subscriber: AnyCancellable?
    
    init(value: String, delay: Double = 0.3) {
        self._value = Published.init(initialValue: value)
        self._debouncedValue = Published.init(initialValue: value)
        
        subscriber = $value
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .sink { [unowned self] value in
                self.debouncedValue = value
            }
    }
}
