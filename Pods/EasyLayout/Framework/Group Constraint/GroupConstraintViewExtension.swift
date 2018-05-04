//
//  GroupConstraintViewExtension.swift
//  EasyLayout
//
//  Created by Blake Tsuzaki on 7/30/17.
//  Copyright © 2017 Modoki. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

extension View {
    static prefix func | (right: View) -> EasyGroupConstraint {
        guard let superview = right.superview else { fatalError() }
        return EasyGroupConstraint(EasyGroupConstraintToken(first: right,
                                                         firstEdge: .leading,
                                                         second: superview,
                                                         secondEdge: .leading,
                                                         spacing: 0), view: right)
    }
    
    static prefix func |- (right: View) -> EasyGroupConstraint {
        guard let superview = right.superview else { fatalError() }
        return EasyGroupConstraint(EasyGroupConstraintToken(first: right,
                                                         firstEdge: .leading,
                                                         second: superview,
                                                         secondEdge: .leading,
                                                         spacing: 10), view: right)
    }
    
    static postfix func | (left: View) -> EasyGroupConstraint {
        guard let superview = left.superview else { fatalError() }
        return EasyGroupConstraint(EasyGroupConstraintToken(first: left,
                                                         firstEdge: .trailing,
                                                         second: superview,
                                                         secondEdge: .trailing,
                                                         spacing: 0), view: left)
    }
    
    static postfix func -| (left: View) -> EasyGroupConstraint {
        guard let superview = left.superview else { fatalError() }
        return EasyGroupConstraint(EasyGroupConstraintToken(first: left,
                                                         firstEdge: .trailing,
                                                         second: superview,
                                                         secondEdge: .trailing,
                                                         spacing: 10), view: left)
    }
    
    static func | (left: View, right: View) -> EasyGroupConstraint {
        return EasyGroupConstraint(EasyGroupConstraintToken(first: left,
                                                         firstEdge: .trailing,
                                                         second: right,
                                                         secondEdge: .leading,
                                                         spacing: 0), views: [left, right])
    }
    
    static func - (left: View, right: View) -> EasyGroupConstraint {
        return EasyGroupConstraint(EasyGroupConstraintToken(first: left,
                                                         firstEdge: .trailing,
                                                         second: right,
                                                         secondEdge: .leading,
                                                         spacing: 10), views: [left, right])
    }
    
    static func - (left: EasyGroupConstraint, right: View) -> EasyGroupConstraint {
        if left.layoutTokens.last?.second != nil {
            guard let leadingView = left.right else { fatalError() }
            left.layoutTokens.append(EasyGroupConstraintToken(first: leadingView,
                                                             firstEdge: .trailing,
                                                             second: right,
                                                             secondEdge: .leading,
                                                             spacing: 10))
        } else {
            var token = left.layoutTokens[left.layoutTokens.count - 1]
            if token.first == nil {
                token.first = right.superview
            }
            token.second = right
            left.layoutTokens[left.layoutTokens.count - 1] = token
        }
        
        left.views.append(right)
        return left
    }
    
    static func - (left: View, right: CGFloat) -> EasyGroupConstraint {
        return EasyGroupConstraint(EasyGroupConstraintToken(first: left,
                                                         firstEdge: .trailing,
                                                         second: nil,
                                                         secondEdge: .leading,
                                                         spacing: right), views: [left])
    }
    
    static func - (left: View, right: EasyGroupConstraint) -> EasyGroupConstraint {
        guard let trailingView = right.left else { fatalError() }
        right.layoutTokens.append(EasyGroupConstraintToken(first: left,
                                                          firstEdge: .trailing,
                                                          second: trailingView,
                                                          secondEdge: .leading,
                                                          spacing: 10))
        right.views.insert(left, at: 0)
        return right
    }
}
