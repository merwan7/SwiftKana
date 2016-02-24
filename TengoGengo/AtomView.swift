//
//  AtomView.swift
//  TengoGengo
//
//  Created by Merwan Rodriguez on 12/19/15.
//  Copyright © 2015 Merwan Rodriguez. All rights reserved.
//

import UIKit
import AVFoundation


class AtomView: UIButton, UIGestureRecognizerDelegate {
    
    var fillColor = UIColor.redColor()
    var strokeColor = UIColor.whiteColor()
    var label = UILabel()
    var initialString = "x"
    var translation = "y"
    var isTranslation: Bool!
    var atomRadius: CGFloat = 30
    var atomDiameter: CGFloat
    var fontSize: CGFloat = 30.0
    var stringAttributes: NSDictionary = NSDictionary()
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var snap: UISnapBehavior!
    var delegate: AtomViewDelegate?
    var originalCenter: CGPoint!
    var parentView: UIView!
    var voiceSynth = AVSpeechSynthesizer()

    
    override var selected: Bool {
        willSet (newSelected) {
            if (selected != newSelected) {
                let tmpColor: UIColor = fillColor
                fillColor = strokeColor
                strokeColor = tmpColor
            }
        } didSet {
            if (true || selected) {
                delegate?.atomWasSelected?(self)
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        var path = UIBezierPath(ovalInRect: rect)
        strokeColor.setFill()
        path.fill()
        
        let childWidth = rect.size.width - 5
        let offset = (rect.size.width / 2) - (childWidth / 2)
        path = UIBezierPath(ovalInRect: CGRectMake(rect.origin.x + offset, rect.origin.y + offset, childWidth, childWidth))
        fillColor.setFill()
        path.fill()
        
        super.drawRect(rect)
        setTitleColor(strokeColor, forState: .Normal)

    }
    
    required init?(coder aDecoder: NSCoder) {
        atomDiameter = atomRadius * 2
        super.init(coder: aDecoder)
    }
    
    init(x: CGFloat, y: CGFloat, syllable: String, translation: String, inView: UIView, isTranslation: Bool) {
        atomDiameter = atomRadius * 2
        parentView = inView
        self.isTranslation = isTranslation
        super.init(frame:CGRectMake(x , y, atomDiameter, atomDiameter))
        originalCenter = center
        frame = CGRectMake(parentView.center.x, parentView.center.y, atomDiameter, atomDiameter)
        setupGestureRecognizers()
        setupUIDynamics()
        loadText(syllable, language2: translation)

    }
    
    func setupUIDynamics() {
        animator = UIDynamicAnimator(referenceView: parentView)
        snap = UISnapBehavior(item: self, snapToPoint: originalCenter)
    }
    
    func setupGestureRecognizers() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action:Selector("handlePan:"))
        let tapRecognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        addGestureRecognizer(panRecognizer)
        addGestureRecognizer(tapRecognizer)
    }
    
    func loadText(language1: String = "", language2: String = "") {
        initialString = language1
        translation = language2
        titleLabel?.font = UIFont(name: "Helvetica", size: fontSize)
        titleLabel?.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        if (!isTranslation) {
            contentEdgeInsets = UIEdgeInsetsMake(-atomRadius / 10, 0, 0, 0)
        }
        setTitle(initialString, forState: .Normal)
        setTitle("", forState: .Disabled)
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        if (state != UIControlState.Disabled) {
            var utterance: AVSpeechUtterance;
            if (!self.isTranslation) {
                utterance = AVSpeechUtterance(string: initialString)
            } else {
                utterance = AVSpeechUtterance(string: translation)
            }
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")

            if (!self.selected) {
                voiceSynth.speakUtterance(utterance)
            }
            selected = !self.selected
        }
    }
    
    func handleDrag(recognizer: UIPanGestureRecognizer) {
        if (self.collision == nil) {
            collision = UICollisionBehavior(items: [self])
            collision.translatesReferenceBoundsIntoBoundary = true
        }
        
        animator.removeAllBehaviors()
        let location: CGPoint = recognizer.locationInView(parentView)
        let offset = UIOffsetMake(location.x, location.y)
        attachmentBehavior = UIAttachmentBehavior(item: self, offsetFromCenter: offset, attachedToAnchor: location)
        center = attachmentBehavior.anchorPoint
        animator.addBehavior(attachmentBehavior)
        animator.addBehavior(collision)
        
    }
    
    func snapIntoPlace() {
        animator.removeAllBehaviors()
        animator.addBehavior(snap)
        
    }
    
    func handleDragEnd(recognizer: UIPanGestureRecognizer) {
        snapIntoPlace()
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        if (recognizer.state == .Ended) {
            handleDragEnd(recognizer)
        } else {
            handleDrag(recognizer)
        }
    }
    
    func handleMatched(moleculeRadius: CGFloat) {        
        animator.removeAllBehaviors()
        snap = UISnapBehavior(item: self, snapToPoint: parentView.center)
        animator.addBehavior(snap)
        
        self.selected = false
        self.enabled = false
        self.setNeedsDisplay()
        self.parentView.bringSubviewToFront(self)
        
        let mr = moleculeRadius
        UIView.animateWithDuration(0.420, delay: 0.2, options: .TransitionCrossDissolve, animations: {
            let coefficient:CGFloat = 1.0
            let size:CGFloat = self.frame.size.width + mr * coefficient
            self.frame = CGRectMake(self.frame.origin.x - (mr / 2), self.frame.origin.y - (mr / 2), size, size)
            }, completion: nil)
    }
    
// MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
}

// MARK: Protocol
@objc protocol AtomViewDelegate {
    optional func atomWasSelected(atom: AtomView)
}
