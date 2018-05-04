//
//  EasyLayoutViewControllerExtension.swift
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

extension ViewController {
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func replace(_ constraint: UnsafeMutablePointer<NSLayoutConstraint>, with newConstraint: NSLayoutConstraint) {
        replace(constraint, with: newConstraint, priority: .now)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func replace(_ constraint: UnsafeMutablePointer<NSLayoutConstraint>, with newConstraint: NSLayoutConstraint, priority: EasyLayoutUpdatePriority) {
        view.replace(constraint, with: newConstraint, priority: priority)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func activate(_ constraints: [NSLayoutConstraint]) {
        activate(constraints, for: nil)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func activate(_ constraints: [NSLayoutConstraint], for views: [View]?) {
        activate(constraints, for: views, priority: .eventually)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func activate(_ constraints: [NSLayoutConstraint], for views: [View]?, priority: EasyLayoutUpdatePriority) {
        view.activate(constraints, for: views, priority: priority)
    }
    
    @objc public func disableTranslatesAutoresizingMask(_ views: [View]) {
        for view in views { view.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    @objc public func addSubviews(_ views: Any) {
        view.addSubviews(views)
    }
    
    public func activate(_ constraints: NSLayoutConstraint..., for views: [View]? = nil, priority: EasyLayoutUpdatePriority = .eventually) {
        view.activate(constraints, for: views, priority: priority)
    }
    
    public func replace(_ constraint: inout NSLayoutConstraint?, with newConstraint: NSLayoutConstraint, priority: EasyLayoutUpdatePriority = .now) {
        view.replace(&constraint, with: newConstraint, priority: priority)
    }
    
    public func replace(_ constraints: inout [NSLayoutConstraint]?, with newConstraints: [NSLayoutConstraint], priority: EasyLayoutUpdatePriority = .now) {
        view.replace(&constraints, with: newConstraints, priority: priority)
    }
}

