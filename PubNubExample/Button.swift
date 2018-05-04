//
//  Button.swift
//  Example
//
//  Created by Blake Tsuzaki on 7/13/17.
//  Copyright © 2017 Iolani School. All rights reserved.
//

import UIKit
import EasyLayout

class Button: UIControl {
    private let buttonTop = UIView()
    private let buttonSides = UIView()
    private let buttonSidesLayer = CAShapeLayer()
    private let buttonSidesGradientLayer = CAGradientLayer()
    private let buttonBottom = UIView()
    private let buttonBottomSpacerView = UIView()
    private let buttonPressAnimationDuration: CFTimeInterval = 0.05
    private let buttonPressPulseDuration: CFTimeInterval = 0.15
    private let buttonPressPulseCount: Float = 2
    private let buttonOutlineMultiplier: CGFloat = 0.05
    private let buttonRoundingMultiplier: CGFloat = 0.5
    fileprivate let buttonPulseDelay: TimeInterval = 5
    
    private var buttonBottomConstraint: NSLayoutConstraint?
    private var wasTouchContainedInView = false
    private var buttonOutlineWidth: CGFloat = 0 {
        didSet {
            buttonSidesLayer.lineWidth = buttonOutlineWidth * 2
            buttonTop.layer.borderWidth = buttonOutlineWidth
            buttonBottom.layer.borderWidth = buttonOutlineWidth
        }
    }
    private var buttonSidesPathNormal: UIBezierPath {
        let buttonSidesArcBottomCenterY = max(0, buttonSides.frame.height - buttonSides.frame.width * buttonRoundingMultiplier)
        let path = UIBezierPath()
        path.move(to: CGPoint())
        path.addLine(to: CGPoint(x: buttonSides.frame.width, y: 0))
        path.addLine(to: CGPoint(x: buttonSides.frame.width, y: buttonSidesArcBottomCenterY))
        path.addArc(withCenter: CGPoint(x: buttonSides.frame.width - buttonSides.frame.width * buttonRoundingMultiplier, y: buttonSidesArcBottomCenterY),
                    radius: buttonSides.frame.width * buttonRoundingMultiplier,
                    startAngle: 0,
                    endAngle: CGFloat.pi / 2,
                    clockwise: true)
        path.addLine(to: CGPoint(x: buttonSides.frame.width * buttonRoundingMultiplier, y: buttonSides.frame.height))
        path.addArc(withCenter: CGPoint(x: buttonSides.frame.width * buttonRoundingMultiplier, y: buttonSidesArcBottomCenterY),
                    radius: buttonSides.frame.width * buttonRoundingMultiplier,
                    startAngle: CGFloat.pi / 2,
                    endAngle: CGFloat.pi,
                    clockwise: true)
        path.addLine(to: CGPoint())
        
        return path
    }
    private var buttonSidesPathPressed: UIBezierPath {
        let path = UIBezierPath()
        let buttonHeight = frame.height - buttonTop.frame.height
        let buttonSidesArcBottomCenterY = max(0, buttonSides.frame.height - buttonSides.frame.width * buttonRoundingMultiplier)
        path.move(to: CGPoint(x: 0, y: buttonHeight))
        path.addLine(to: CGPoint(x: buttonSides.frame.width, y: buttonHeight))
        path.addLine(to: CGPoint(x: buttonSides.frame.width, y: buttonSidesArcBottomCenterY))
        path.addArc(withCenter: CGPoint(x: buttonSides.frame.width - buttonSides.frame.width * buttonRoundingMultiplier, y: buttonSidesArcBottomCenterY),
                    radius: buttonSides.frame.width * buttonRoundingMultiplier,
                    startAngle: 0,
                    endAngle: CGFloat.pi / 2,
                    clockwise: true)
        path.addLine(to: CGPoint(x: buttonSides.frame.width * buttonRoundingMultiplier, y: buttonSides.frame.height))
        path.addArc(withCenter: CGPoint(x: buttonSides.frame.width * buttonRoundingMultiplier, y: buttonSidesArcBottomCenterY),
                    radius: buttonSides.frame.width * buttonRoundingMultiplier,
                    startAngle: CGFloat.pi / 2,
                    endAngle: CGFloat.pi,
                    clockwise: true)
        path.addLine(to: CGPoint())
        return path
    }
    fileprivate var buttonSidesAnimation: CABasicAnimation {
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = buttonSidesPathNormal.cgPath
        pathAnimation.toValue = buttonSidesPathPressed.cgPath
        pathAnimation.duration = buttonPressAnimationDuration
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        pathAnimation.isRemovedOnCompletion = false
        return pathAnimation
    }
    fileprivate var buttonTopAnimation: CABasicAnimation {
        let topAnimation = CABasicAnimation(keyPath: "position.y")
        topAnimation.fromValue = buttonTop.center.y
        topAnimation.toValue = frame.height - buttonTop.frame.height / 2
        topAnimation.duration = buttonPressAnimationDuration
        topAnimation.fillMode = kCAFillModeForwards
        topAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        topAnimation.isRemovedOnCompletion = false
        return topAnimation
    }
    fileprivate var isAnimatingPulse = false
    fileprivate var shouldPausePulse = false
    
    var contentView: UIView { return buttonTop }
    var buttonBottomEnabled: Bool = false {
        didSet {
            buttonBottom.isHidden = !buttonBottomEnabled
        }
    }
    var shouldAnimatePulse: Bool = false {
        didSet {
            isAnimatingPulse = shouldAnimatePulse
            if shouldAnimatePulse { animateButtonPulse() }
        }
    }
    override var tintColor: UIColor! {
        didSet {
            buttonTop.backgroundColor = tintColor.darker()
            buttonSidesGradientLayer.colors = [tintColor.cgColor, tintColor.darker(by: 60).cgColor as Any]
        }
    }
    
    init() {
        super.init(frame: CGRect())
        
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureViews()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        shouldPausePulse = true
        
        animateButtonPress()
        
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let isContainedInView = touch.isContained(in: self)
        
        if isContainedInView != wasTouchContainedInView {
            wasTouchContainedInView = isContainedInView
            
            if isContainedInView { animateButtonPress() }
            else { animateButtonRelease() }
        }
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        animateButtonRelease()
        
        shouldPausePulse = false
        if shouldAnimatePulse && !isAnimatingPulse {
            isAnimatingPulse = true
            DispatchQueue.main.asyncAfter(deadline: .now() + buttonPulseDelay, execute: {
                self.animateButtonPulse()
            })
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        buttonTop.layer.cornerRadius = buttonTop.frame.width * buttonRoundingMultiplier
        
        buttonBottom.layer.cornerRadius = buttonBottom.frame.width * buttonRoundingMultiplier
        
        let buttonSidesMask = CAShapeLayer()
        buttonSidesMask.path = buttonSidesPathNormal.cgPath
        buttonSides.layer.mask = buttonSidesMask
        buttonSidesLayer.path = buttonSidesPathNormal.cgPath
        
        buttonSidesGradientLayer.frame = buttonSides.bounds
        
        buttonOutlineWidth = buttonSides.frame.width * buttonOutlineMultiplier
    }
    
    private func configureViews() {
        addSubviews([buttonBottom, buttonSides, buttonTop, buttonBottomSpacerView])
        
        buttonBottom.isUserInteractionEnabled = false
        buttonBottom.backgroundColor = .white
        buttonBottom.layer.borderWidth = buttonOutlineWidth
        buttonBottom.layer.borderColor = UIColor.black.cgColor
        buttonBottom.isHidden = true
        
        buttonSides.isUserInteractionEnabled = false
        buttonSides.layer.addSublayer(buttonSidesGradientLayer)
        buttonSides.layer.addSublayer(buttonSidesLayer)
        
        buttonSidesGradientLayer.colors = [tintColor.cgColor, tintColor.darker().cgColor as Any]
        buttonSidesGradientLayer.locations = [0, 0.5]
        buttonSidesGradientLayer.startPoint = CGPoint()
        buttonSidesGradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        buttonSidesLayer.fillColor = UIColor.clear.cgColor
        buttonSidesLayer.strokeColor = UIColor.black.cgColor
        buttonSidesLayer.lineWidth = buttonOutlineWidth * 2
        
        buttonTop.isUserInteractionEnabled = false
        buttonTop.backgroundColor = tintColor.darker()
        buttonTop.layer.borderColor = UIColor.black.cgColor
        buttonTop.layer.borderWidth = buttonOutlineWidth
        
        buttonBottomSpacerView.isUserInteractionEnabled = false
        buttonBottomSpacerView.backgroundColor = .clear
        
        let buttonBottomConstraint = buttonBottom.centerY == buttonSides.bottom - buttonSides.frame.width/2.2
        
        activate(
            buttonSides.left == self,
            buttonSides.right == self,
            buttonSides.bottom == self,
            buttonSides.top == buttonTop.centerY,
            
            buttonTop.height == buttonTop.width,
            buttonTop.width == buttonSides,
            buttonTop.centerX == buttonSides,
            buttonTop.top == self,
            
            buttonBottom.height == buttonBottom.width,
            buttonBottom.width == buttonTop.width * 1.2,
            buttonBottom.centerX == buttonSides,
            buttonBottom.bottom == buttonBottomSpacerView.bottom,
            
            buttonBottomSpacerView.width == buttonSides.width,
            buttonBottomSpacerView.height == buttonSides.width / 8,
            buttonBottomSpacerView.top == buttonSides.bottom,
            buttonBottomSpacerView.centerX == buttonSides.centerX
        )
        
        self.buttonBottomConstraint = buttonBottomConstraint
    }
    
    private func animateButtonPress() {
        buttonSides.layer.mask?.add(buttonSidesAnimation, forKey: "animation")
        buttonSidesLayer.add(buttonSidesAnimation, forKey: "animation")
        buttonTop.layer.add(buttonTopAnimation, forKey: "animation")
        
        UIView.animate(withDuration: 0.2) {
            self.buttonTop.backgroundColor = self.tintColor.lighter()
        }
    }
    
    private func animateButtonRelease() {
        let buttonSidesAnimation = self.buttonSidesAnimation
        buttonSidesAnimation.swapToFromValues()
        buttonSidesAnimation.isRemovedOnCompletion = true
        let buttonTopAnimation = self.buttonTopAnimation
        buttonTopAnimation.swapToFromValues()
        buttonTopAnimation.isRemovedOnCompletion = true
        
        buttonSides.layer.mask?.removeAnimation(forKey: "animation")
        buttonSidesLayer.removeAnimation(forKey: "animation")
        buttonTop.layer.removeAnimation(forKey: "animation")
        
        buttonSides.layer.mask?.add(buttonSidesAnimation, forKey: "animation")
        buttonSidesLayer.add(buttonSidesAnimation, forKey: "animation")
        buttonTop.layer.add(buttonTopAnimation, forKey: "animation")
        
        buttonTop.backgroundColor = tintColor.darker()
    }
    
    fileprivate func animateButtonPulse() {
        let buttonSidesAnimation = self.buttonSidesAnimation
        let buttonTopAnimation = self.buttonTopAnimation
        
        buttonSidesAnimation.fillMode = kCAFillModeForwards
        buttonSidesAnimation.duration = buttonPressPulseDuration
        buttonSidesAnimation.autoreverses = true
        buttonSidesAnimation.repeatCount = buttonPressPulseCount
        buttonSidesAnimation.isRemovedOnCompletion = true
        buttonTopAnimation.fillMode = kCAFillModeForwards
        buttonTopAnimation.duration = buttonPressPulseDuration
        buttonTopAnimation.autoreverses = true
        buttonTopAnimation.repeatCount = buttonPressPulseCount
        buttonTopAnimation.isRemovedOnCompletion = true
        buttonTopAnimation.delegate = self
        
        buttonSides.layer.mask?.add(buttonSidesAnimation, forKey: "animation")
        buttonSidesLayer.add(buttonSidesAnimation, forKey: "animation")
        buttonTop.layer.add(buttonTopAnimation, forKey: "animation")
    }
}

extension Button: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isAnimatingPulse = false
        if !shouldPausePulse && !isAnimatingPulse && shouldAnimatePulse {
            self.isAnimatingPulse = true
            DispatchQueue.main.asyncAfter(deadline: .now() + buttonPulseDelay) {
                if self.shouldPausePulse || !self.shouldAnimatePulse { self.isAnimatingPulse = false }
                else { self.animateButtonPulse() }
            }
        }
    }
}
