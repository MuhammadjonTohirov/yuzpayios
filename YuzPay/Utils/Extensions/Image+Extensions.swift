//
//  Image+Extensions.swift
//  YuzPay
//
//  Created by applebro on 02/04/23.
//

import Foundation
import SwiftUI

extension Image {
    public func resizable(_ resizable: Bool) -> some View {
        Group {
            if resizable {
                self.resizable()
            } else {
                self
            }
        }
    }
    
    public func sizeToFit(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height, alignment: alignment)
    }
    
    @_disfavoredOverload
    public func sizeToFit(
        _ size: CGSize? = nil,
        alignment: Alignment = .center
    ) -> some View {
        sizeToFit(width: size?.width, height: size?.height, alignment: alignment)
    }
    
    public func sizeToFitSquare(
        sideLength: CGFloat?,
        alignment: Alignment = .center
    ) -> some View {
        sizeToFit(width: sideLength, height: sideLength, alignment: alignment)
    }
}

