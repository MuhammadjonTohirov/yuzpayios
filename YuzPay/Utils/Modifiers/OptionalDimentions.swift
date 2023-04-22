//
//  OptionalDimentions.swift
//  YuzPay
//
//  Created by applebro on 02/04/23.
//

import Foundation
import SwiftUI

@_frozen
public struct OptionalDimensions: ExpressibleByNilLiteral, Hashable {
    public var width: CGFloat?
    public var height: CGFloat?
    
    @inlinable
    public init(width: CGFloat?, height: CGFloat?) {
        self.width = width
        self.height = height
    }
    
    @inlinable
    public init(_ size: CGSize) {
        self.init(width: size.width, height: size.height)
    }
    
    @inlinable
    public init(_ size: CGSize?) {
        if let size = size {
            self.init(size)
        } else {
            self.init(nilLiteral: ())
        }
    }
    
    @inlinable
    public init(nilLiteral: ()) {
        self.init(width: nil, height: nil)
    }
    
    @inlinable
    public init() {
        
    }
}

extension OptionalDimensions {
    public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        .init(
            width: width?.rounded(rule),
            height: height?.rounded(rule)
        )
    }

    public mutating func clamp(to dimensions: OptionalDimensions) {
        if let maxWidth = dimensions.width {
            if let width = self.width {
                self.width = min(width, maxWidth)
            } else {
                self.width = maxWidth
            }
        }
        
        if let maxHeight = dimensions.height {
            if let height = self.height {
                self.height = min(height, maxHeight)
            } else {
                self.height = maxHeight
            }
        }
    }
    
    public func clamped(to dimensions: OptionalDimensions?) -> Self {
        guard let dimensions = dimensions else {
            return self
        }

        var result = self
        
        result.clamp(to: dimensions)
        
        return result
    }
    
    public func drop(_ axes: Axis.Set) -> Self {
        Self.init(
            width: axes.contains(.horizontal) ? nil : 0,
            height: axes.contains(.vertical) ? nil : 0
        )
    }
}
