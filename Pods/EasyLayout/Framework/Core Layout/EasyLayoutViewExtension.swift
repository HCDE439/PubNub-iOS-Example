//
//  EasyLayoutViewExtension.swift
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
    @objc public var height: EasyLayoutToken { return EasyLayoutToken(attribute: .height, view: self) }
    @objc public var width: EasyLayoutToken { return EasyLayoutToken(attribute: .width, view: self) }
    @objc public var top: EasyLayoutToken { return EasyLayoutToken(attribute: .top, view: self) }
    @objc public var bottom: EasyLayoutToken { return EasyLayoutToken(attribute: .bottom, view: self) }
    @objc public var left: EasyLayoutToken { return EasyLayoutToken(attribute: .left, view: self) }
    @objc public var right: EasyLayoutToken { return EasyLayoutToken(attribute: .right, view: self) }
    @objc public var centerX: EasyLayoutToken { return EasyLayoutToken(attribute: .centerX, view: self) }
    @objc public var centerY: EasyLayoutToken { return EasyLayoutToken(attribute: .centerY, view: self) }
    @objc public var leading: EasyLayoutToken { return EasyLayoutToken(attribute: .leading, view: self) }
    @objc public var trailing: EasyLayoutToken { return EasyLayoutToken(attribute: .trailing, view: self) }
    @objc public var lastBaseline: EasyLayoutToken { return EasyLayoutToken(attribute: .lastBaseline, view: self) }
    
    @objc public var concreteFrame: CGRect {
        var tempView: View? = self
        var point = CGPoint()
        var frame = self.frame
        while let view = tempView {
            point.x += view.frame.origin.x
            point.y += view.frame.origin.y
            #if os(iOS)
            if let view = tempView as? UIScrollView {
                point.x -= view.contentOffset.x
                point.y -= view.contentOffset.y
                
            }
            #endif
            tempView = view.superview
        }
        
        frame.origin = point
        return frame
    }
    
    @objc public func concreteFrame(in superview: View) -> CGRect {
        var tempView: View? = self
        var point = CGPoint()
        var frame = self.frame
        while let view = tempView, tempView != superview {
            point.x += view.frame.origin.x
            point.y += view.frame.origin.y
            #if os(iOS)
            if let view = tempView as? UIScrollView {
                point.x -= view.contentOffset.x
                point.y -= view.contentOffset.y
            }
            #endif
            tempView = view.superview
        }
        
        frame.origin = point
        return frame
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func replace(_ constraint: UnsafeMutablePointer<NSLayoutConstraint>, with newConstraint: NSLayoutConstraint) {
        replace(constraint, with: newConstraint, priority: .now)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func replace(_ constraint: UnsafeMutablePointer<NSLayoutConstraint>, with newConstraint: NSLayoutConstraint, priority: EasyLayoutUpdatePriority) {
        
        let oldConstraint = constraint.pointee
        oldConstraint.isActive = false
        removeConstraint(oldConstraint)
        
        newConstraint.isActive = true
        
        #if os(iOS)
            switch priority {
            case .now: self.layoutIfNeeded()
            case .eventually: self.setNeedsLayout()
            case .whenever: break
            }
        #endif
        
        constraint.pointee = newConstraint
    }
    
    @objc public func disableTranslatesAutoresizingMask(_ views: [View]) {
        for view in views { view.translatesAutoresizingMaskIntoConstraints = false }
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
        disableTranslatesAutoresizingMask(views ?? subviews)
        NSLayoutConstraint.activate(constraints)
        
        #if os(iOS)
            switch priority {
            case .now: layoutIfNeeded()
            case .eventually: setNeedsLayout()
            case .whenever: break
            }
        #endif
    }
    
    @objc public func addSubviews(_ views: Any) {
        var viewArr = [View]()
        
        if let views = views as? [View] {
            viewArr = views
        } else if let viewList = views as? [String: View] {
            viewArr = Array(viewList.values)
        }
        
        for view in viewArr { addSubview(view) }
    }
    
    public static func * (left: View, right: CGFloat) -> EasyLayoutToken {
        return EasyLayoutToken(attribute: nil, view: left, multiplier: right, constant: 0)
    }
    
    public static func * (left: CGFloat, right: View) -> EasyLayoutToken {
        return right * left
    }
    
    public static func / (left: View, right: CGFloat) -> EasyLayoutToken {
        return left * (1 / right)
    }
    
    public func activate(_ constraints: NSLayoutConstraint..., for views: [View]? = nil, priority: EasyLayoutUpdatePriority = .eventually) {
        disableTranslatesAutoresizingMask(views ?? subviews)
        NSLayoutConstraint.activate(constraints)
        
        #if os(iOS)
            switch priority {
            case .now: layoutIfNeeded()
            case .eventually: setNeedsLayout()
            case .whenever: break
            }
        #endif
    }
    
    public func replace(_ constraint: inout NSLayoutConstraint?, with newConstraint: NSLayoutConstraint, priority: EasyLayoutUpdatePriority = .now) {
        if let constraint = constraint {
            constraint.isActive = false
            removeConstraint(constraint)
        }
        newConstraint.isActive = true
        
        #if os(iOS)
            switch priority {
            case .now: self.layoutIfNeeded()
            case .eventually: self.setNeedsLayout()
            case .whenever: break
            }
        #endif
        
        constraint = newConstraint
    }
    
    public func replace(_ constraints: inout [NSLayoutConstraint]?, with newConstraints: [NSLayoutConstraint], priority: EasyLayoutUpdatePriority = .now) {
        if let constraints = constraints {
            for constraint in constraints {
                constraint.isActive = false
                removeConstraint(constraint)
            }
        }
        for constraint in newConstraints { constraint.isActive = true }
        
        #if os(iOS)
            switch priority {
            case .now: layoutIfNeeded()
            case .eventually: setNeedsLayout()
            case .whenever: break
            }
        #endif
        
        constraints = newConstraints
    }
}
