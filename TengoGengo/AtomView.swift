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
    var delegate: AtomViewDelegate?;
    
    override var selected: Bool {
        willSet (newSelected) {
            if (selected != newSelected) {
                let tmpColor: UIColor = self.fillColor;
                self.fillColor = self.strokeColor;
                self.strokeColor = tmpColor;
            }
        } didSet {
            if (self.selected) {
                self.delegate?.atomWasSelected?(self);
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        var path = UIBezierPath(ovalInRect: rect);
        self.strokeColor.setFill();
        path.fill();
        
        // Doing this for two reasons:
        // a - I'm a newb to this stuff
        // b - when I set strokeWidth to something large, it gets clipped (rectangleishly), so I'm faking it.
        
        let childWidth = rect.size.width - 5;
        let offset = (rect.size.width / 2) - (childWidth / 2);
        path = UIBezierPath(ovalInRect: CGRectMake(rect.origin.x + offset, rect.origin.y + offset, childWidth, childWidth));
        self.fillColor.setFill();
        path.fill();
        super.drawRect(rect);
        self.setTitleColor(self.strokeColor, forState: .Normal);

    }
    
    required init?(coder aDecoder: NSCoder) {
        self.atomDiameter = self.atomRadius * 2;
        super.init(coder: aDecoder);

        //self.contentEdgeInsets = UIEdgeInsetsMake(-self.fontSize / 8, 0, 0, 0); // there's gotta be a better way to center this text.
    }
    
    init(x: CGFloat, y: CGFloat, syllable: String, translation: String) {
        self.atomDiameter = self.atomRadius * 2;
        super.init(frame:CGRectMake(x , y, self.atomDiameter, self.atomDiameter));
        
        //self.contentEdgeInsets = UIEdgeInsetsMake(-self.fontSize / 8, 0, 0, 0); // there's gotta be a better way to center this text.
        setupGestureRecognizers();
        loadText(syllable, language2: translation);

    }
    
    func setupGestureRecognizers() {
        //let panRecognizer = UIPanGestureRecognizer(target: self, action:Selector("handlePan:"));
        let tapRecognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"));
        //panRecognizer.delegate = self;
        tapRecognizer.delegate = self;
        
        //self.addGestureRecognizer(panRecognizer);
        self.addGestureRecognizer(tapRecognizer);
    }
    
    func loadText(language1: String = "", language2: String = "") {
        self.initialString = language1;
        self.translation = language2;
        self.titleLabel?.font = UIFont(name: "Helvetica", size: self.fontSize);
        self.titleLabel?.baselineAdjustment = UIBaselineAdjustment.AlignCenters;
        self.setTitle(self.initialString, forState: .Normal);
        self.setTitle(self.translation, forState: .Disabled);
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        if (self.state != UIControlState.Disabled) {
            self.selected = !self.selected;
        }
    }
    
//    func handlePan(recognizer: UIPanGestureRecognizer) {
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
//    }
    
// MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
}

// MARK: Protocol
@objc protocol AtomViewDelegate {
    optional func atomWasSelected(atom: AtomView);
}
