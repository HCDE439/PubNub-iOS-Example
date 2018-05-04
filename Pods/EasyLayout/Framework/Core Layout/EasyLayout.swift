//
//  EasyLayout.swift
//  Example
//
//  Created by Blake Tsuzaki on 7/30/17.
//  Copyright © 2017 Modoki. All rights reserved.
//

#if os(iOS)
    import UIKit
    public typealias View = UIView
    public typealias ViewController = UIViewController
    public typealias LayoutAttribute = NSLayoutAttribute
#elseif os(OSX)
    import AppKit
    public typealias View = NSView
    public typealias ViewController = NSViewController
    public typealias LayoutAttribute = NSLayoutConstraint.Attribute
#endif

@objc public enum EasyLayoutUpdatePriority: Int {
    case now, eventually, whenever
}

public class EasyLayoutToken: NSObject {
    var attribute: LayoutAttribute?
    var view: View
    var multiplier: CGFloat
    var constant: CGFloat
    
    fileprivate static let leftAttributeError = "Left operand layout attribute cannot be nil"
    
    convenience init(attribute: LayoutAttribute?, view: View) {
        self.init(attribute: attribute, view: view, multiplier: 1, constant: 0)
    }
    
    init(attribute: LayoutAttribute?, view: View, multiplier: CGFloat, constant: CGFloat) {
        self.attribute = attribute
        self.view = view
        self.multiplier = multiplier
        self.constant = constant
        
        super.init()
    }
}

public extension EasyLayoutToken {
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func equalTo(view: View) -> NSLayoutConstraint {
        return equalTo(view: view, multiplier: 1, offset: 0)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func equalTo(view: View, multiplier: CGFloat) -> NSLayoutConstraint {
        return equalTo(view: view, multiplier: multiplier, offset: 0)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func equalTo(view: View, offset: CGFloat) -> NSLayoutConstraint {
        return equalTo(view: view, multiplier: 1, offset: offset)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func equalTo(view: View, multiplier: CGFloat, offset: CGFloat) -> NSLayoutConstraint {
        return equalTo(EasyLayoutToken(attribute: attribute, view: view), multiplier: multiplier, offset: offset)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func equalTo(_ token: EasyLayoutToken) -> NSLayoutConstraint {
        return equalTo(token, multiplier: 1, offset: 0)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func equalTo(_ token: EasyLayoutToken, multiplier: CGFloat) -> NSLayoutConstraint {
        return equalTo(token, multiplier: multiplier, offset: 0)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func equalTo(_ token: EasyLayoutToken, offset: CGFloat) -> NSLayoutConstraint {
        return equalTo(token, multiplier: 1, offset: offset)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func equalTo(_ token: EasyLayoutToken, multiplier: CGFloat, offset: CGFloat) -> NSLayoutConstraint {
        return self == token * multiplier + offset
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func lessThan(view: View) -> NSLayoutConstraint {
        return lessThan(view: view, multiplier: 1, offset: 0)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func lessThan(view: View, multiplier: CGFloat) -> NSLayoutConstraint {
        return lessThan(view: view, multiplier: multiplier, offset: 0)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func lessThan(view: View, offset: CGFloat) -> NSLayoutConstraint {
        return lessThan(view: view, multiplier: 1, offset: offset)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func lessThan(view: View, multiplier: CGFloat, offset: CGFloat) -> NSLayoutConstraint {
        return lessThan(EasyLayoutToken(attribute: attribute, view: view), multiplier: multiplier, offset: offset)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func lessThan(_ token: EasyLayoutToken) -> NSLayoutConstraint {
        return lessThan(token, multiplier: 1, offset: 0)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func lessThan(_ token: EasyLayoutToken, multiplier: CGFloat) -> NSLayoutConstraint {
        return lessThan(token, multiplier: multiplier, offset: 0)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func lessThan(_ token: EasyLayoutToken, offset: CGFloat) -> NSLayoutConstraint {
        return lessThan(token, multiplier: 1, offset: offset)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func lessThan(_ token: EasyLayoutToken, multiplier: CGFloat, offset: CGFloat) -> NSLayoutConstraint {
        return self < token * multiplier + offset
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func greaterThan(view: View) -> NSLayoutConstraint {
        return greaterThan(view: view, multiplier: 1, offset: 0)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func greaterThan(view: View, multiplier: CGFloat) -> NSLayoutConstraint {
        return greaterThan(view: view, multiplier: multiplier, offset: 0)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func greaterThan(view: View, offset: CGFloat) -> NSLayoutConstraint {
        return greaterThan(view: view, multiplier: 1, offset: offset)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func greaterThan(view: View, multiplier: CGFloat, offset: CGFloat) -> NSLayoutConstraint {
        return greaterThan(EasyLayoutToken(attribute: attribute, view: view), multiplier: multiplier, offset: offset)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func greaterThan(_ token: EasyLayoutToken) -> NSLayoutConstraint {
        return greaterThan(token, multiplier: 1, offset: 0)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func greaterThan(_ token: EasyLayoutToken, multiplier: CGFloat) -> NSLayoutConstraint {
        return greaterThan(token, multiplier: multiplier, offset: 0)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func greaterThan(_ token: EasyLayoutToken, offset: CGFloat) -> NSLayoutConstraint {
        return greaterThan(token, multiplier: 1, offset: offset)
    }
    
    @available(swift, deprecated: 0.1, message: "For use in Objective C code only")
    @objc public func greaterThan(_ token: EasyLayoutToken, multiplier: CGFloat, offset: CGFloat) -> NSLayoutConstraint {
        return self > token * multiplier + offset
    }
    
    static func == (left: EasyLayoutToken, right: EasyLayoutToken) -> NSLayoutConstraint {
        guard let leftAttribute = left.attribute else { fatalError(leftAttributeError) }
        return NSLayoutConstraint(item: left.view,
                                  attribute: leftAttribute,
                                  relatedBy: .equal,
                                  toItem: right.view,
                                  attribute: right.attribute ?? leftAttribute,
                                  multiplier: left.multiplier * right.multiplier,
                                  constant: left.constant + right.constant)
    }
    
    static func == (left: EasyLayoutToken, right: View) -> NSLayoutConstraint {
        guard let leftAttribute = left.attribute else { fatalError(leftAttributeError) }
        return NSLayoutConstraint(item: left.view,
                                  attribute: leftAttribute,
                                  relatedBy: .equal,
                                  toItem: right,
                                  attribute: leftAttribute,
                                  multiplier: left.multiplier,
                                  constant: left.constant)
    }
    
    static func == (left: View, right: EasyLayoutToken) -> NSLayoutConstraint {
        return right == left
    }
    
    static func == (left: EasyLayoutToken, right: CGFloat) -> NSLayoutConstraint {
        guard let leftAttribute = left.attribute else { fatalError(leftAttributeError) }
        return NSLayoutConstraint(item: left.view,
                                  attribute: leftAttribute,
                                  relatedBy: .equal,
                                  toItem: nil,
                                  attribute: .notAnAttribute,
                                  multiplier: left.multiplier,
                                  constant: left.constant)
    }
    
    static func == (left: CGFloat, right: EasyLayoutToken) -> NSLayoutConstraint {
        return right == left
    }
    
    static func < (left: EasyLayoutToken, right: EasyLayoutToken) -> NSLayoutConstraint {
        guard let leftAttribute = left.attribute else { fatalError(leftAttributeError) }
        return NSLayoutConstraint(item: left.view,
                                  attribute: leftAttribute,
                                  relatedBy: .lessThanOrEqual,
                                  toItem: right.view,
                                  attribute: right.attribute ?? leftAttribute,
                                  multiplier: left.multiplier * right.multiplier,
                                  constant: left.constant + right.constant)
    }
    
    static func < (left: EasyLayoutToken, right: View) -> NSLayoutConstraint {
        guard let leftAttribute = left.attribute else { fatalError(leftAttributeError) }
        return NSLayoutConstraint(item: left.view,
                                  attribute: leftAttribute,
                                  relatedBy: .lessThanOrEqual,
                                  toItem: right,
                                  attribute: leftAttribute,
                                  multiplier: left.multiplier,
                                  constant: left.constant)
    }
    
    static func > (left: View, right: EasyLayoutToken) -> NSLayoutConstraint {
        return right < left
    }
    
    static func < (left: EasyLayoutToken, right: CGFloat) -> NSLayoutConstraint {
        guard let leftAttribute = left.attribute else { fatalError(leftAttributeError) }
        return NSLayoutConstraint(item: left.view,
                                  attribute: leftAttribute,
                                  relatedBy: .lessThanOrEqual,
                                  toItem: nil,
                                  attribute: .notAnAttribute,
                                  multiplier: left.multiplier,
                                  constant: left.constant)
    }
    
    static func > (left: CGFloat, right: EasyLayoutToken) -> NSLayoutConstraint {
        return right < left
    }
    
    static func <= (left: EasyLayoutToken, right: EasyLayoutToken) -> NSLayoutConstraint {
        return left < right
    }
    
    static func <= (left: EasyLayoutToken, right: View) -> NSLayoutConstraint {
        return left < right
    }
    
    static func <= (left: EasyLayoutToken, right: CGFloat) -> NSLayoutConstraint {
        return left < right
    }
    
    static func > (left: EasyLayoutToken, right: EasyLayoutToken) -> NSLayoutConstraint {
        guard let leftAttribute = left.attribute else { fatalError(leftAttributeError) }
        return NSLayoutConstraint(item: left.view,
                                  attribute: leftAttribute,
                                  relatedBy: .greaterThanOrEqual,
                                  toItem: right.view,
                                  attribute: right.attribute ?? leftAttribute,
                                  multiplier: left.multiplier * right.multiplier,
                                  constant: left.constant + right.constant)
    }
    
    static func > (left: EasyLayoutToken, right: View) -> NSLayoutConstraint {
        guard let leftAttribute = left.attribute else { fatalError(leftAttributeError) }
        return NSLayoutConstraint(item: left.view,
                                  attribute: leftAttribute,
                                  relatedBy: .greaterThanOrEqual,
                                  toItem: right,
                                  attribute: leftAttribute,
                                  multiplier: left.multiplier,
                                  constant: left.constant)
    }
    
    static func < (left: View, right: EasyLayoutToken) -> NSLayoutConstraint {
        return right > left
    }
    
    static func > (left: EasyLayoutToken, right: CGFloat) -> NSLayoutConstraint {
        guard let leftAttribute = left.attribute else { fatalError(leftAttributeError) }
        return NSLayoutConstraint(item: left.view,
                                  attribute: leftAttribute,
                                  relatedBy: .lessThanOrEqual,
                                  toItem: nil,
                                  attribute: .notAnAttribute,
                                  multiplier: left.multiplier,
                                  constant: left.constant)
    }
    
    static func < (left: CGFloat, right: EasyLayoutToken) -> NSLayoutConstraint {
        return right > left
    }
    
    static func >= (left: EasyLayoutToken, right: EasyLayoutToken) -> NSLayoutConstraint {
        return left > right
    }
    
    static func >= (left: EasyLayoutToken, right: View) -> NSLayoutConstraint {
        return left > right
    }
    
    static func >= (left: EasyLayoutToken, right: CGFloat) -> NSLayoutConstraint {
        return left > right
    }
    
    static func * (left: EasyLayoutToken, right: CGFloat) -> EasyLayoutToken {
        return EasyLayoutToken(attribute: left.attribute, view: left.view, multiplier: right, constant: left.constant)
    }
    
    static func * (left: CGFloat, right: EasyLayoutToken) -> EasyLayoutToken {
        return right * left
    }
    
    static func / (left: EasyLayoutToken, right: CGFloat) -> EasyLayoutToken {
        return left * (1 / right)
    }
    
    static func + (left: EasyLayoutToken, right: CGFloat) -> EasyLayoutToken {
        return EasyLayoutToken(attribute: left.attribute, view: left.view, multiplier: left.multiplier, constant: right)
    }
    
    static func + (left: CGFloat, right: EasyLayoutToken) -> EasyLayoutToken {
        return right + left
    }
    
    static func - (left: EasyLayoutToken, right: CGFloat) -> EasyLayoutToken {
        return left + (-right)
    }
    
    static func - (left: CGFloat, right: EasyLayoutToken) -> EasyLayoutToken {
        return right + (-left)
    }
}
