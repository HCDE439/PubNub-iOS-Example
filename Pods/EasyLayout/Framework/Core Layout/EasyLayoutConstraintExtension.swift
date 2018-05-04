//
//  EasyLayoutConstraintExtension.swift
//  EasyLayout
//
//  Created by Blake Tsuzaki on 7/30/17.
//  Copyright © 2017 Modoki. All rights reserved.
//

#if os(iOS)
    import UIKit
    public typealias LayoutPriority = UILayoutPriority
#elseif os(OSX)
    import AppKit
    public typealias LayoutPriority = NSLayoutConstraint.Priority
#endif

precedencegroup EasyLayoutPriorityPrecedence { higherThan: AssignmentPrecedence }

infix operator ~: EasyLayoutPriorityPrecedence

extension NSLayoutConstraint {
    #if os(iOS)
    public static func ~ (left: NSLayoutConstraint, right: LayoutPriority) -> NSLayoutConstraint {
        let constraint = left
        constraint.priority = right
        return constraint
    }
    
    public static func ~ (left: LayoutPriority, right: NSLayoutConstraint) -> NSLayoutConstraint {
        return right ~ left
    }
    #elseif os(OSX)
    public static func ~ (left: NSLayoutConstraint, right: NSLayoutConstraint.Priority) -> NSLayoutConstraint {
        let constraint = left
        constraint.priority = right
        return constraint
    }
    
    public static func ~ (left: NSLayoutConstraint.Priority, right: NSLayoutConstraint) -> NSLayoutConstraint {
        return right ~ left
    }
    #endif
}
