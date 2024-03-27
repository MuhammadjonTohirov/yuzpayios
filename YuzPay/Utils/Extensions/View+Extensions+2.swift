//
//  View+Extensions+2.swift
//  YuzPay
//
//  Created by applebro on 02/04/23.
//

import SwiftUI

extension View {
    /// Causes the view to greedily fill into its container.
    @inlinable
    public func frame(
        _ size: _GreedyFrameSize,
        alignment: Alignment = .center
    ) -> some View {
        modifier(GreedyFrameModifer(width: .greedy, height: .greedy, alignment: alignment))
    }
    
    @inlinable
    public func frame(
        width: _GreedyFrameSize,
        alignment: Alignment = .center
    ) -> some View {
        modifier(GreedyFrameModifer(width: .greedy, height: nil, alignment: alignment))
    }
    
    @inlinable
    public func frame(
        width: _GreedyFrameSize,
        height: CGFloat?,
        alignment: Alignment = .center
    ) -> some View {
        modifier(GreedyFrameModifer(width: .greedy, height: height.map({ .fixed($0) }), alignment: alignment))
    }
    
    @inlinable
    public func frame(
        width: CGFloat?,
        height: _GreedyFrameSize,
        alignment: Alignment = .center
    ) -> some View {
        modifier(GreedyFrameModifer(width: width.map({ .fixed($0) }), height: .greedy, alignment: alignment))
    }
    
    @inlinable
    public func frame(
        height: _GreedyFrameSize,
        alignment: Alignment = .center
    ) -> some View {
        modifier(GreedyFrameModifer(width: nil, height: .greedy, alignment: alignment))
    }
    
    @inlinable
    public func frame(
        _ size: _GreedyFrameSize,
        _ axis: Axis,
        alignment: Alignment = .center
    ) -> some View {
        switch axis {
            case .horizontal:
                return modifier(GreedyFrameModifer(width: .greedy, height: nil, alignment: alignment))
            case .vertical:
                return modifier(GreedyFrameModifer(width: nil, height: .greedy, alignment: alignment))
        }
    }
    
    @available(*, message: "greedyFrame() is deprecated, use frame(.greedy) instead")
    public func greedyFrame(alignment: Alignment = .center) -> some View {
        frame(.greedy)
    }
}

extension View {
    @inlinable
    public func relativeHeight(
        _ ratio: CGFloat,
        alignment: Alignment = .center
    ) -> some View {
        GeometryReader { geometry in
            self.frame(
                height: geometry.size.height * ratio,
                alignment: alignment
            )
        }
    }
    
    @inlinable
    public func relativeWidth(
        _ ratio: CGFloat,
        alignment: Alignment = .center
    ) -> some View {
        GeometryReader { geometry in
            self.frame(
                width: geometry.size.width * ratio,
                alignment: alignment
            )
        }
    }
    
    @inlinable
    public func relativeSize(
        width widthRatio: CGFloat?,
        height heightRatio: CGFloat?,
        alignment: Alignment = .center
    ) -> some View {
        GeometryReader { geometry in
            self.frame(
                width: widthRatio.map({ $0 * geometry.size.width }),
                height: heightRatio.map({ $0 * geometry.size.height }),
                alignment: alignment
            )
        }
    }
}

extension View {
    /// Causes the view to fill into its container.
    @inlinable
    public func fill(alignment: Alignment = .center) -> some View {
        relativeSize(width: 1.0, height: 1.0, alignment: alignment)
    }
}

extension View {
    /// Causes the view to greedily fill to fit into its container.
    @inlinable
    public func fit() -> some View {
        GeometryReader { geometry in
            self.frame(
                width: geometry.size.minimumDimensionLength,
                height: geometry.size.minimumDimensionLength
            )
        }
    }
}

extension View {
    @inlinable
    public func width(_ width: CGFloat?) -> some View {
        frame(width: width)
    }
    
    @inlinable
    public func height(_ height: CGFloat?) -> some View {
        frame(height: height)
    }
    
    /// Positions this view within an invisible frame with the specified size.
    ///
    /// Use this method to specify a fixed size for a view's width,
    /// height, or both. If you only specify one of the dimensions, the
    /// resulting view assumes this view's sizing behavior in the other
    /// dimension.
    @inlinable
    public func frame(_ size: CGSize?, alignment: Alignment = .center) -> some View {
        frame(width: size?.width, height: size?.height, alignment: alignment)
    }
    
    /// Positions this view within an invisible frame with the specified size.
    ///
    /// Use this method to specify a fixed size for a view's width,
    /// height, or both. If you only specify one of the dimensions, the
    /// resulting view assumes this view's sizing behavior in the other
    /// dimension.
    @inlinable
    public func frame(min size: CGSize?, alignment: Alignment = .center) -> some View {
        frame(minWidth: size?.width, minHeight: size?.height, alignment: alignment)
    }
    
    /// Positions this view within an invisible frame with the specified size.
    ///
    /// Use this method to specify a fixed size for a view's width,
    /// height, or both. If you only specify one of the dimensions, the
    /// resulting view assumes this view's sizing behavior in the other
    /// dimension.
    @inlinable
    public func frame(max size: CGSize?, alignment: Alignment = .center) -> some View {
        frame(maxWidth: size?.width, maxHeight: size?.height, alignment: alignment)
    }
    /// Positions this view within an invisible frame with the specified size.
    ///
    /// Use this method to specify a fixed size for a view's width,
    /// height, or both. If you only specify one of the dimensions, the
    /// resulting view assumes this view's sizing behavior in the other
    /// dimension.
    @inlinable
    public func frame(
        min minSize: CGSize?,
        max maxSize: CGSize?,
        alignment: Alignment = .center
    ) -> some View {
        frame(
            minWidth: minSize?.width,
            maxWidth: maxSize?.width,
            minHeight: minSize?.height,
            maxHeight: maxSize?.height,
            alignment: alignment
        )
    }
}

extension View {
    @inlinable
    public func minWidth(_ width: CGFloat?) -> some View {
        frame(minWidth: width)
    }
    
    @inlinable
    public func maxWidth(_ width: CGFloat?) -> some View {
        frame(maxWidth: width)
    }
    
    @inlinable
    public func minHeight(_ height: CGFloat?) -> some View {
        frame(minHeight: height)
    }
    
    @inlinable
    public func maxHeight(_ height: CGFloat?) -> some View {
        frame(maxHeight: height)
    }
    
    @inlinable
    public func frame(min dimensionLength: CGFloat, axis: Axis) -> some View {
        switch axis {
            case .horizontal:
                return frame(minWidth: dimensionLength)
            case .vertical:
                return frame(minWidth: dimensionLength)
        }
    }
}

extension View {
    /// Positions this view within an invisible frame having the specified ideal size constraints.
    @inlinable
    public func idealFrame(width: CGFloat?, height: CGFloat?) -> some View {
        frame(idealWidth: width, idealHeight: height)
    }
    
    /// Positions this view within an invisible frame having the specified ideal size constraints.
    @inlinable
    public func idealMinFrame(
        width: CGFloat?,
        maxWidth: CGFloat? = nil,
        height: CGFloat?,
        maxHeight: CGFloat? = nil
    ) -> some View {
        frame(
            minWidth: width,
            idealWidth: width,
            maxWidth: maxWidth,
            minHeight: height,
            idealHeight: height,
            maxHeight: maxHeight
        )
    }
}

extension View {
    @inlinable
    public func squareFrame(sideLength: CGFloat?, alignment: Alignment = .center) -> some View {
        frame(width: sideLength, height: sideLength, alignment: alignment)
    }
    
    @inlinable
    public func squareFrame() -> some View {
        GeometryReader { geometry in
            self.frame(width: geometry.size.minimumDimensionLength, height: geometry.size.minimumDimensionLength)
        }
    }
}

extension View {
    @inlinable
    public func frameZeroClipped(_ clipped: Bool = true) -> some View {
        frame(clipped ? .zero : nil)
            .clipped()
    }
}

// MARK: - Auxiliary Implementation -

@usableFromInline
protocol _opaque_FrameModifier {
    func dimensionsThatFit(in dimensions: OptionalDimensions) -> OptionalDimensions
}

@usableFromInline
protocol _opaque_FrameModifiedContent {
    var _opaque_frameModifier: _opaque_FrameModifier { get }
}

@_frozen
public enum _GreedyFrameSize {
    case greedy
}

@usableFromInline
struct GreedyFrameModifer: _opaque_FrameModifier, ViewModifier {
    @_frozen
    @usableFromInline
    enum Dimension {
        case fixed(CGFloat)
        case greedy
        
        @usableFromInline
        var fixedValue: CGFloat? {
            guard case .fixed(let value) = self else {
                return nil
            }
            
            return value
        }
        
        @usableFromInline
        func resolve(in container: OptionalDimensions) -> CGFloat? {
            switch self {
                case .fixed(let value):
                    return value
                case .greedy:
                    return container.width
            }
        }
    }
    
    @usableFromInline
    let width: Dimension?
    @usableFromInline
    let height: Dimension?
    @usableFromInline
    let alignment: Alignment
    
    @usableFromInline
    init(width: Dimension?, height: Dimension?, alignment: Alignment) {
        self.width = width
        self.height = height
        self.alignment = alignment
    }
    
    @usableFromInline
    func body(content: Content) -> some View {
        content.frame(
            minWidth: width?.fixedValue,
            idealWidth: width?.resolve(in: .greatestFiniteDimensions),
            maxWidth: width?.resolve(in: .greatestFiniteDimensions),
            minHeight: height?.fixedValue,
            idealHeight: height?.resolve(in: .greatestFiniteDimensions),
            maxHeight: height?.resolve(in: .greatestFiniteDimensions),
            alignment: alignment
        )
    }
    
    @usableFromInline
    func dimensionsThatFit(in dimensions: OptionalDimensions) -> OptionalDimensions {
        .init(width: width?.resolve(in: dimensions), height: height?.resolve(in: dimensions))
    }
}

extension OptionalDimensions {
    fileprivate static var greatestFiniteDimensions: OptionalDimensions {
        .init(width: .greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
    }

    fileprivate static var infinite: OptionalDimensions {
        .init(width: .infinity, height: .infinity)
    }
}

extension ModifiedContent: _opaque_FrameModifiedContent where Modifier: _opaque_FrameModifier {
    @usableFromInline
    var _opaque_frameModifier: _opaque_FrameModifier {
        modifier
    }
}

extension View {
    func _precomputedDimensionsThatFit(
        in dimensions: OptionalDimensions
    ) -> OptionalDimensions? {
        if let self = self as? _opaque_FrameModifiedContent {
            return self._opaque_frameModifier.dimensionsThatFit(in: dimensions)
        } else {
            return nil
        }
    }
    
    func _precomputedDimensionsThatFit(
        in dimensions: CGSize
    ) -> OptionalDimensions? {
        _precomputedDimensionsThatFit(in: .init(dimensions))
    }
}

extension View {
    @available(*, deprecated, message: "Please use View.border(_:width:cornerRadius:antialiased:) instead.")
    public func border<S: ShapeStyle>(
        _ content: S,
        cornerRadius: CGFloat,
        width lineWidth: CGFloat,
        antialiased: Bool
    ) -> some View {
        self.cornerRadius(cornerRadius, antialiased: antialiased)
            .overlay(
                LineWidthInsetRoundedRectangle(
                    cornerRadius: cornerRadius,
                    style: .circular,
                    lineWidth: lineWidth
                )
                .stroke(content, lineWidth: lineWidth)
            )
            .padding(lineWidth / 2)
    }
    
    @available(*, deprecated, message: "Please use View.border(_:width:cornerRadius:style:) instead.")
    public func border<S: ShapeStyle>(
        _ content: S,
        cornerRadius: CGFloat,
        width lineWidth: CGFloat,
        style: RoundedCornerStyle = .circular
    ) -> some View {
        clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: style))
            .overlay(
                LineWidthInsetRoundedRectangle(
                    cornerRadius: cornerRadius,
                    style: style,
                    lineWidth: lineWidth
                )
                .stroke(content, lineWidth: lineWidth)
            )
            .padding(lineWidth / 2)
    }
    
    public func cornerRadius(_ radius: CGFloat, style: RoundedCornerStyle) -> some View {
        clipShape(RoundedRectangle(cornerRadius: radius, style: style))
    }
    
    public func foregroundLinearGradient(
        _ gradient: Gradient,
        startPoint: UnitPoint = .leading,
        endPoint: UnitPoint = .trailing
    ) -> some View {
        overlay(
            LinearGradient(
                gradient: gradient,
                startPoint: startPoint,
                endPoint: endPoint
            )
        )
        .mask(self)
    }
}

private struct LineWidthInsetRoundedRectangle: Shape {
    let cornerRadius: CGFloat
    let style: RoundedCornerStyle
    let lineWidth: CGFloat
    
    init(
        cornerRadius: CGFloat,
        style: RoundedCornerStyle = .circular,
        lineWidth: CGFloat
    ) {
        self.cornerRadius = cornerRadius
        self.style = style
        self.lineWidth = lineWidth
    }
    
    func path(in rect: CGRect) -> Path {
        let ratio = (cornerRadius / rect.size.minimumDimensionLength)
        let newCornerRadius = ratio * (rect.size.minimumDimensionLength + (lineWidth * 2))
        
        return RoundedRectangle(cornerRadius: newCornerRadius, style: style)
            .path(in: rect)
    }
}

extension View {
    #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
    public func contentInsetAdjustmentBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> some View {
        environment(\.contentInsetAdjustmentBehavior, behavior)
    }
    
    /// Sets the keyboard dismiss mode for this view.
    @available(tvOS, unavailable)
    public func keyboardDismissMode(_ keyboardDismissMode: UIScrollView.KeyboardDismissMode) -> some View {
        environment(\.keyboardDismissMode, keyboardDismissMode)
    }
    #endif
    
    /// Adds a condition that controls whether users can scroll within this view.
    public func scrollDisabled(_ disabled: Bool) -> some View {
        environment(\.isScrollEnabled, !disabled)
    }
    
    @available(*, message: "isScrollEnabled(_:) is deprecated, use scrollDisabled(_:) instead")
    public func isScrollEnabled(_ isEnabled: Bool) -> some View {
        environment(\.isScrollEnabled, isEnabled)
    }
}

extension EnvironmentValues {
    #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
    private struct ContentInsetAdjustmentBehaviorKey: EnvironmentKey {
        static let defaultValue: UIScrollView.ContentInsetAdjustmentBehavior? = nil
    }
    
    public var contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior? {
        get {
            self[ContentInsetAdjustmentBehaviorKey.self]
        } set {
            self[ContentInsetAdjustmentBehaviorKey.self] = newValue
        }
    }
    
    @available(tvOS, unavailable)
    private struct KeyboardDismissModeKey: EnvironmentKey {
        static let defaultValue: UIScrollView.KeyboardDismissMode = .none
    }
    
    @available(tvOS, unavailable)
    public var keyboardDismissMode: UIScrollView.KeyboardDismissMode {
        get {
            self[KeyboardDismissModeKey.self]
        } set {
            self[KeyboardDismissModeKey.self] = newValue
        }
    }
    #endif
    
    private struct IsScrollEnabledEnvironmentKey: EnvironmentKey {
        static let defaultValue = true
    }
    
    public var isScrollEnabled: Bool {
        get {
            self[IsScrollEnabledEnvironmentKey.self]
        } set {
            self[IsScrollEnabledEnvironmentKey.self] = newValue
        }
    }
}
