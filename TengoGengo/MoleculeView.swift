//
//  Game.swift
//  TengoGengo
//
//  Created by Merwan Rodriguez on 12/19/15.
//  Copyright © 2015 Merwan Rodriguez. All rights reserved.
//

import UIKit

class MoleculeView: NSObject, AtomViewDelegate {

    var currentSet: JSON = [:];
    var allAtoms = [String : AtomView]();
    var pairedUpCount = 0;
    var lastSelected: AtomView?;
    var gameContentView: UIView;
    
    // Animation variables
    var animator: UIDynamicAnimator!;
    var gravity: UIGravityBehavior!;
    var collision: UICollisionBehavior!;
    
    init(gameView: UIView) {
        self.gameContentView = gameView;
        
        super.init();
        loadData();
        createButtons();
        addButtonsToView();
        addPhysics();
    }
    
    func addPhysics() {
        animator = UIDynamicAnimator(referenceView: self.gameContentView);
        gravity = UIGravityBehavior(items: Array(allAtoms.values));
        collision = UICollisionBehavior(items: Array(allAtoms.values));
        collision.translatesReferenceBoundsIntoBoundary = true

        animator.addBehavior(collision);
        animator.addBehavior(gravity);
    }
    
    func createButtons() {
        var index:CGFloat = 1.0;
        
        for (key,value):(String, JSON) in currentSet {
            let atom = AtomView(x: index * 50, y: index * 25, syllable: value.stringValue, translation: key);
            let pairAtom = AtomView(x: index * 50 + 50, y: index * 25 + 50 , syllable: key, translation: value.stringValue);
            allAtoms[atom.initialString] = atom;
            allAtoms[pairAtom.initialString] = pairAtom;
            index += 1;
        }
    }
    
    func addButtonsToView() {
        for atom in allAtoms {
            atom.1.delegate = self;
            self.gameContentView.addSubview(atom.1);
        }
    }
    
    
    func loadData() {
        if let path = NSBundle.mainBundle().pathForResource("japanese", ofType: "json")
        {
            if let jsonData = try? NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            {
                japaneseNormalizer(JSON(data: jsonData), key: "h", desiredType: "Hiragana");
            }
        }
    }
    
    func japaneseNormalizer(jsonResult: JSON, key: String, desiredType: String) {
        for (_, subJSON):(String, JSON) in jsonResult[key] {
            let seion = subJSON["Seion"];
            //let dakuon = subJSON["Dakuon"];
            //let handakuon = subJSON["Handakuon"];
            
            let romaji = seion["Romaji"].stringValue;
            let hiragana = seion[desiredType].stringValue;
            currentSet[romaji].string = hiragana;
            
//            romaji = dakuon["Romaji"].stringValue;
//            hiragana = dakuon[desiredType].stringValue;
//            currentState[romaji].string = hiragana;
//            
//            romaji = handakuon["Romaji"].stringValue;
//            hiragana = handakuon[desiredType].stringValue;
//            currentState[romaji].string = hiragana;
        }
        print(currentSet);
    }

// MARK: AtomViewDelegate
    func atomWasSelected(atom: AtomView) {
        print(atom.initialString + ": " + atom.translation);
        
        if (atom.initialString == self.lastSelected?.translation) {
            lastSelected?.frame = CGRectZero;
            atom.frame = CGRectZero;
            self.lastSelected = nil;

            self.pairedUpCount += 2;
            
            if (self.pairedUpCount == allAtoms.count) {
                print("you win!");
            }
        } else if (self.lastSelected != nil) {
            let delay = 0.2 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                atom.selected = false;
                self.lastSelected?.selected = false;
                self.lastSelected = nil;
            }
        } else {
            self.lastSelected = atom;
        }
    }
}
