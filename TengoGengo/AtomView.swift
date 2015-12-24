//
//  AtomView.swift
//  TengoGengo
//
//  Created by Merwan Rodriguez on 12/19/15.
//  Copyright © 2015 Merwan Rodriguez. All rights reserved.
//

import UIKit

class AtomView: UIButton, UIGestureRecognizerDelegate {
    
    var fillColor = UIColor.redColor();
    var strokeColor = UIColor.whiteColor();
    var label = UILabel();
    var initialString = "x";
    var translation = "y";
    var atomRadius: CGFloat = 30;
    var atomDiameter: CGFloat;
    var fontSize: CGFloat = 30.0;
    var stringAttributes: NSDictionary = NSDictionary();
    var animator: UIDynamicAnimator!;
    var attachmentBehavior: UIAttachmentBehavior!;
    var gravity: UIGravityBehavior!;
    var collision: UICollisionBehavior!;
    var snap: UISnapBehavior!;
    var delegate: AtomViewDelegate?;
    var originalCenter: CGPoint!;
    
    override var selected: Bool {
        willSet (newSelected) {
            if (selected != newSelected) {
                let tmpColor: UIColor = fillColor;
                fillColor = strokeColor;
                strokeColor = tmpColor;
            }
        } didSet {
            if (selected) {
                delegate?.atomWasSelected?(self);
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        var path = UIBezierPath(ovalInRect: rect);
        strokeColor.setFill();
        path.fill();
        
        // Doing this for two reasons:
        // a - I'm a newb to this stuff
        // b - when I set strokeWidth to something large, it gets clipped (rectangleishly), so I'm faking it.
        
        let childWidth = rect.size.width - 5;
        let offset = (rect.size.width / 2) - (childWidth / 2);
        path = UIBezierPath(ovalInRect: CGRectMake(rect.origin.x + offset, rect.origin.y + offset, childWidth, childWidth));
        fillColor.setFill();
        path.fill();
        super.drawRect(rect);
        setTitleColor(strokeColor, forState: .Normal);

    }
    
    required init?(coder aDecoder: NSCoder) {
        self.atomDiameter = atomRadius * 2;
        super.init(coder: aDecoder);

        //self.contentEdgeInsets = UIEdgeInsetsMake(-self.fontSize / 8, 0, 0, 0); // there's gotta be a better way to center this text.
    }
    
    init(x: CGFloat, y: CGFloat, syllable: String, translation: String) {
        atomDiameter = atomRadius * 2;
        super.init(frame:CGRectMake(x , y, atomDiameter, atomDiameter));
        
        originalCenter = center;
        setupGestureRecognizers();
        loadText(syllable, language2: translation);

    }
    
    func setupGestureRecognizers() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action:Selector("handlePan:"));
        let tapRecognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"));
        addGestureRecognizer(panRecognizer);
        addGestureRecognizer(tapRecognizer);
    }
    
    func loadText(language1: String = "", language2: String = "") {
        initialString = language1;
        translation = language2;
        titleLabel?.font = UIFont(name: "Helvetica", size: fontSize);
        titleLabel?.baselineAdjustment = UIBaselineAdjustment.AlignCenters;
        setTitle(initialString, forState: .Normal);
        setTitle(translation, forState: .Disabled);
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        if (state != UIControlState.Disabled) {
            selected = !self.selected;
        }
    }
    
    func handleDrag(recognizer: UIPanGestureRecognizer) {
//        if (self.gravity == nil) {
//            self.gravity = UIGravityBehavior(items: [self]);
//        }
        
        if (self.collision == nil) {
            collision = UICollisionBehavior(items: [self]);
            collision.translatesReferenceBoundsIntoBoundary = true
        }
        animator.removeAllBehaviors();
        let location: CGPoint = recognizer.locationInView(superview);
        let offset = UIOffsetMake(location.x, location.y)
        attachmentBehavior = UIAttachmentBehavior(item: self, offsetFromCenter: offset, attachedToAnchor: location);
        center = attachmentBehavior.anchorPoint;
        animator.addBehavior(attachmentBehavior);
//        self.animator.addBehavior(gravity);
        animator.addBehavior(collision);
        
        //        let translation = recognizer.translationInView(self);
        //
        //        if recognizer.state == UIGestureRecognizerState.Ended {
        //            let velocity = recognizer.velocityInView(self);
        //            let magnitude = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2));
        //            let slideMultiplier = magnitude / 420;
        //            let slideFactor = 0.01 * slideMultiplier;
        //
        //            var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
        //                y:recognizer.view!.center.y + (velocity.y * slideFactor));
        //
        //            finalPoint.x = min(max(finalPoint.x, self.atomDiameter), self.superview!.bounds.size.width - self.atomDiameter);
        //            finalPoint.y = min(max(finalPoint.y, self.atomDiameter), self.superview!.bounds.size.height - self.atomDiameter);
        //
        //            UIView.animateWithDuration(Double(slideFactor * 2),
        //                delay: 0,
        //                options: UIViewAnimationOptions.CurveEaseOut,
        //                animations: {recognizer.view!.center = finalPoint},
        //                completion: nil);
        //
        //        } else {
        //            if let view = recognizer.view {
        //                view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y);
        //            }
        //            recognizer.setTranslation(CGPointZero, inView: self);
        //        }
    }
    
    func handleDragEnd(recognizer: UIPanGestureRecognizer) {
        if (snap == nil) {
            snap = UISnapBehavior(item: self, snapToPoint: originalCenter)
        }
        
        animator.removeAllBehaviors()
        animator.addBehavior(snap)
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        if (animator == nil) {
            animator = UIDynamicAnimator(referenceView: superview!);
        }
        
        if (recognizer.state == .Ended) {
            handleDragEnd(recognizer)
        } else {
            handleDrag(recognizer)
        }
    }
    
    func handleMatched() {
        if (animator == nil) {
            animator = UIDynamicAnimator(referenceView: superview!);
        }
        
        if (snap == nil) {
            snap = UISnapBehavior(item: self, snapToPoint: originalCenter)
        }
        
        animator.removeAllBehaviors()
        snap = UISnapBehavior(item: self, snapToPoint: superview!.center);
        animator.addBehavior(snap);
    }
    
// MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
}

// MARK: Protocol
@objc protocol AtomViewDelegate {
    optional func atomWasSelected(atom: AtomView);
}
