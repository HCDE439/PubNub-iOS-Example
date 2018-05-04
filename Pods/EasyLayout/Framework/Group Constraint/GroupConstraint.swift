//
//  GroupConstraint.swift
//  EasyLayout
//
//  Created by Blake Tsuzaki on 7/31/17.
//  Copyright © 2017 Modoki. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

prefix operator |
prefix operator |-
postfix operator |
postfix operator -|

enum EasyGroupConstraintDirection { case horizontal, vertical }

struct EasyGroupConstraintToken {
    enum EdgeType { case leading, trailing }
    var first: View?
    var firstEdge: EdgeType
    var second: View?
    var secondEdge: EdgeType
    var spacing: CGFloat
    
    fileprivate func constraint(for direction: EasyGroupConstraintDirection) -> NSLayoutConstraint {
        guard let first = first, let second = second else { fatalError() }
        switch direction {
        case .horizontal: return (firstEdge == .leading ? first.left : first.right) - spacing == (secondEdge == .leading ? second.left : second.right)
        case .vertical: return (firstEdge == .leading ? first.top : first.bottom) - spacing == (secondEdge == .leading ? second.top : second.bottom)
        }
    }
}

class EasyGroupConstraint: NSLayoutConstraint {
    var horizontal: EasyGroupConstraint {
        for token in layoutTokens {
            constraints.append(token.constraint(for: .horizontal))
        }
        return self
    }
    var vertical: EasyGroupConstraint {
        for token in layoutTokens {
            constraints.append(token.constraint(for: .vertical))
        }
        return self
    }
    internal var layoutTokens = [EasyGroupConstraintToken]()
    internal var left: View? {
        get { return views.first }
        set { if let newValue = newValue { views.insert(newValue, at: 0) } }
    }
    internal var right: View? {
        get { return views.last }
        set { if let newValue = newValue { views.append(newValue) } }
    }
    internal var views = [View]()
    private var constraints = [NSLayoutConstraint]()
    private var _isActive: Bool = false
    
    override init() { super.init() }
    
    internal init(_ token: EasyGroupConstraintToken) {
        super.init()
        layoutTokens.append(token)
    }
    
    internal init(_ token: EasyGroupConstraintToken, view: View) {
        super.init()
        layoutTokens.append(token)
        views.append(view)
    }
    
    internal init(_ token: EasyGroupConstraintToken, views: [View]) {
        super.init()
        layoutTokens.append(token)
        self.views = views
    }
    
    override var isActive: Bool {
        get { return _isActive }
        set {
            _isActive = newValue
            if constraints.count == 0 {
                for token in layoutTokens {
                    constraints.append(token.constraint(for: .horizontal))
                }
            }
            for constraint in constraints {
                constraint.priority = priority
                constraint.isActive = _isActive
            }
        }
    }
    
    static prefix func | (right: EasyGroupConstraint) -> EasyGroupConstraint {
        guard let view = right.left, let superview = view.superview else { fatalError() }
        right.layoutTokens.append(EasyGroupConstraintToken(first: view,
                                                             firstEdge: .leading,
                                                             second: superview,
                                                             secondEdge: .leading,
                                                             spacing: 0))
        return right
    }
    
    static postfix func | (left: EasyGroupConstraint) -> EasyGroupConstraint {
        guard let view = left.right, let superview = view.superview else { fatalError() }
        left.layoutTokens.append(EasyGroupConstraintToken(first: view,
                                                            firstEdge: .trailing,
                                                            second: superview,
                                                            secondEdge: .trailing,
                                                            spacing: 0))
        return left
    }
    
    static func | (left: EasyGroupConstraint, right: EasyGroupConstraint) -> EasyGroupConstraint {
        guard let leadingView = left.right, let trailingView = right.left else { fatalError() }
        left.layoutTokens.append(EasyGroupConstraintToken(first: leadingView,
                                                            firstEdge: .trailing,
                                                            second: trailingView,
                                                            secondEdge: .leading,
                                                            spacing: 0))
        left.layoutTokens += right.layoutTokens
        left.views += right.views
        return left
    }
    
    static func - (left: EasyGroupConstraint, right: EasyGroupConstraint) -> EasyGroupConstraint {
        guard let leadingView = left.right, var leadingToken = left.layoutTokens.last, var trailingToken = right.layoutTokens.first else { fatalError() }
        if leadingToken.second == nil {
            guard let trailingView = right.left else { fatalError() }
            leadingToken.second = trailingView
            left.layoutTokens[left.layoutTokens.count-1] = leadingToken
        } else if trailingToken.first == nil {
            trailingToken.first = leadingView
            trailingToken.second = leadingView.superview
            right.layoutTokens[0] = trailingToken
        } else {
            guard let trailingView = right.left else { fatalError() }
            left.layoutTokens.append(EasyGroupConstraintToken(first: leadingView,
                                                                firstEdge: .trailing,
                                                                second: trailingView,
                                                                secondEdge: .leading,
                                                                spacing: leadingToken.spacing == 0 ? 10 : leadingToken.spacing))
        }
        left.layoutTokens += right.layoutTokens
        left.views += right.views
        return left
    }
    
    static func - (left: EasyGroupConstraint, right: CGFloat) -> EasyGroupConstraint {
        guard let leadingView = left.right else { fatalError() }
        left.layoutTokens.append(EasyGroupConstraintToken(first: leadingView,
                                                            firstEdge: .trailing,
                                                            second: nil,
                                                            secondEdge: .leading,
                                                            spacing: right))
        return left
    }
    
    static postfix func -| (left: EasyGroupConstraint) -> EasyGroupConstraint {
        guard let trailingView = left.right else { fatalError() }
        if left.layoutTokens.last?.second != nil {
            left.layoutTokens.append(EasyGroupConstraintToken(first: trailingView,
                                                             firstEdge: .trailing,
                                                             second: trailingView.superview,
                                                             secondEdge: .trailing,
                                                             spacing: 10))
        } else {
            var token = left.layoutTokens[left.layoutTokens.count - 1]
            token.second = left.layoutTokens.last?.first?.superview
            left.layoutTokens[left.layoutTokens.count - 1] = token
        }
        return left
    }
    
    static func ~ (left: EasyGroupConstraint, right: LayoutPriority) -> NSLayoutConstraint {
        let constraint = left
        constraint.priority = right
        return constraint
    }
    
    static func ~ (left: LayoutPriority, right: EasyGroupConstraint) -> NSLayoutConstraint {
        return right ~ left
    }
}
