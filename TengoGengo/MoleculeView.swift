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
    var gameContentView: UIView!;
    
    init(gameView: UIView, key: String, type: String) {
        super.init();
        
        self.gameContentView = gameView;
        loadData(key, type: type);
        createButtons();
        addButtonsToView();
        //        addPhysics();
    }
    
    
    func createButtons() {
        let step = 2 * M_PI / Double(currentSet.count * 2);
        let h = Double(gameContentView.center.x - 30);
        let k = Double(gameContentView.center.y - 30);
        let r = Double(gameContentView.bounds.width / 2 - 60); // TODO: this -50 should be coming from atom radius
        var theta = 0.0;
        var x:CGFloat = 0.0;
        var y:CGFloat = 0.0;
        
        for (key, value):(String, JSON) in currentSet {
            x = CGFloat(h + r * cos(theta));
            y = CGFloat(k - r * sin(theta));
            let atom = AtomView(x: x, y: y, syllable: value.stringValue, translation: key);
            allAtoms[atom.initialString] = atom;
            theta += step
        }
        
        print(allAtoms.count);
        
        for (key, value):(String, JSON) in currentSet {
            x = CGFloat(h + r * cos(theta));
            y = CGFloat(k - r * sin(theta));
            let pairAtom = AtomView(x: x, y: y, syllable: key, translation: value.stringValue);
            allAtoms[pairAtom.initialString] = pairAtom;
            theta += step;

        }
        

        print(allAtoms.count);
        
//        for (key,value):(String, JSON) in currentSet {
//            let atom = AtomView(x: index * 50, y: index * 25, syllable: value.stringValue, translation: key);
//            let pairAtom = AtomView(x: index * 50 + 50, y: index * 25 + 50 , syllable: key, translation: value.stringValue);
//            allAtoms[atom.initialString] = atom;
//            allAtoms[pairAtom.initialString] = pairAtom;
//            index += 1;
//        }
    }
    
    func addButtonsToView() {
        for atom in allAtoms {
            atom.1.delegate = self;
            self.gameContentView.addSubview(atom.1);
        }
    }
    
    
    func loadData(key: String, type: String) {
        if let path = NSBundle.mainBundle().pathForResource("japanese", ofType: "json")
        {
            if let jsonData = try? NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            {
                japaneseNormalizer(JSON(data: jsonData), key: key, desiredType: type);
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
            lastSelected?.handleMatched();
            atom.handleMatched();
            lastSelected = nil;

            pairedUpCount += 2;
            
            if (pairedUpCount == allAtoms.count) {
                print("you win!");
            }
        } else if (lastSelected != nil) {
            let delay = 0.2 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                atom.selected = false;
                self.lastSelected?.selected = false;
                self.lastSelected = nil;
            }
        } else {
            lastSelected = atom;
        }
    }
}
