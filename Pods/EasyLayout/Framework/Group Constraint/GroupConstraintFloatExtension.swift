//
//  GroupConstraintFloatExtension.swift
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

extension CGFloat {
    static prefix func |- (right: CGFloat) -> EasyGroupConstraint {
        return EasyGroupConstraint(EasyGroupConstraintToken(first: nil,
                                                         firstEdge: .leading,
                                                         second: nil,
                                                         secondEdge: .leading,
                                                         spacing: right))
    }
    static postfix func -| (left: CGFloat) -> EasyGroupConstraint {
        return EasyGroupConstraint(EasyGroupConstraintToken(first: nil,
                                                         firstEdge: .trailing,
                                                         second: nil,
                                                         secondEdge: .trailing,
                                                         spacing: left))
    }
}
