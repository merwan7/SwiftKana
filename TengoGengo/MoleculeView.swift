//
//  Game.swift
//  TengoGengo
//
//  Created by Merwan Rodriguez on 12/19/15.
//  Copyright © 2015 Merwan Rodriguez. All rights reserved.
//

import UIKit

class MoleculeView: NSObject, AtomViewDelegate {

    var JSON_DATA: JSON = [:]
    var currentSet: JSON = [:]
    var allAtoms = [String : AtomView]()
    var pairedUpCount = 0
    var lastSelected: AtomView?
    var gameContentView: UIView!
    var moleculeRadius:CGFloat = 0.0
    var atomDiameter:CGFloat = 60
    var currentKey: String = "h"
    var currentType: String = "hiragana"
    var allKeys: [String] = []
    
    init(gameView: UIView, key: String, type: String) {
        super.init()
        
        self.gameContentView = gameView
        selectSet(key, type: type)
    }
    
    init(gameView: UIView, key: String, type: String, difficulty: String) {
        super.init()
        
        self.gameContentView = gameView
        // selectSet(key, type: type) // TODO: add difficulty set where it is not limited to just 1 type (so you could have ha shi ku re so as a set)
    }
    
    func start() {
        createButtons()
        addButtonsToView()
    }
    
    func reload() {
        cleanup()
        selectSet(currentKey, type: currentType)
    }
    
    func cleanup() {
        gameContentView.subviews.forEach({
            $0.removeFromSuperview()
        })
        lastSelected = nil
        pairedUpCount = 0
        allAtoms = [:]
        currentSet = [:]
    }
    
    func selectSet(key:String, type: String) {
        currentKey = key
        currentType = type
        cleanup()
        if (JSON_DATA.count == 0) {
            loadData()
        }
        japaneseNormalizer(JSON_DATA, key: currentKey, desiredType: currentType)
        start()
    }
    
    func nextSet() {
        var index = Int(allKeys.indexOf(currentKey)!)
        if index == allKeys.count - 1 {
            index = 0
        } else {
            index += 1
        }
        selectSet(allKeys[index], type: currentType)
    }
    
    
    
    func createButtons() {
        let step = 2 * M_PI / Double(currentSet.count * 2)
        let h = Double(gameContentView.center.x - 30)
        let k = Double(gameContentView.center.y - 30)
        let r = Double(gameContentView.bounds.width / 2 - atomDiameter)
        var theta = 0.0
        var x:CGFloat = 0.0
        var y:CGFloat = 0.0
        
        moleculeRadius = CGFloat(r)
        
        for (key, value):(String, JSON) in currentSet {
            x = CGFloat(h + r * cos(theta))
            y = CGFloat(k - r * sin(theta))
            let atom = AtomView(x: x, y: y, syllable: value.stringValue, translation: key, inView: gameContentView, isTranslation: true)
            atom.delegate = self
            allAtoms[atom.initialString] = atom
            theta += step
        }
        
        print(allAtoms.count)
        
        for (key, value):(String, JSON) in currentSet {
            x = CGFloat(h + r * cos(theta))
            y = CGFloat(k - r * sin(theta))
            let pairAtom = AtomView(x: x, y: y, syllable: key, translation: value.stringValue, inView: gameContentView, isTranslation: false)
            pairAtom.delegate = self
            allAtoms[pairAtom.initialString] = pairAtom
            theta += step

        }
        

        print(allAtoms.count)
    }
    
    func addButtonsToView() {
        for atom in allAtoms {
            atom.1.delegate = self // freaky syntax
            self.gameContentView.addSubview(atom.1)
            atom.1.snapIntoPlace()
        }
    }
    
    
    func loadData() {
        
        if let path = NSBundle.mainBundle().pathForResource("japanese", ofType: "json") {
            if let jsonData = try? NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe) {
                JSON_DATA = JSON(data: jsonData)
            }
        }
    }
    
    func japaneseNormalizer(jsonResult: JSON, key: String, desiredType: String) {
        for (keyInSet, _) in jsonResult {
            allKeys.append(keyInSet)
        }
        
        for (_, subJSON):(String, JSON) in jsonResult[key] {
            let seion = subJSON["Seion"]
            //let dakuon = subJSON["Dakuon"];
            //let handakuon = subJSON["Handakuon"];
            
            let romaji = seion["Romaji"].stringValue
            let hiragana = seion[desiredType].stringValue
            currentSet[romaji].string = hiragana
            
//            romaji = dakuon["Romaji"].stringValue;
//            hiragana = dakuon[desiredType].stringValue;
//            currentState[romaji].string = hiragana;
//            
//            romaji = handakuon["Romaji"].stringValue;
//            hiragana = handakuon[desiredType].stringValue;
//            currentState[romaji].string = hiragana;
        }
        print(currentSet)
    }
    
    func win() {
        nextSet() // for now
    }
    

// MARK: AtomViewDelegate
    func atomWasSelected(atom: AtomView) {
        
        // moleculeRadius = gameContentView.bounds.width / 2 - atomDiameter
        print(atom.initialString + ": " + atom.translation)
        
        if (atom.initialString == self.lastSelected?.translation && self.lastSelected!.selected) {
            lastSelected?.handleMatched(moleculeRadius)
            atom.handleMatched(moleculeRadius)
            lastSelected = nil

            pairedUpCount += 2
            
            if (pairedUpCount == allAtoms.count) {
                win()
            }
        } else if (self.lastSelected == atom) {
            self.lastSelected = nil
        } else if (lastSelected != nil) {
            let delay = 0.2 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                atom.selected = false
                self.lastSelected?.selected = false
                self.lastSelected = nil
            }
        } else {
            lastSelected = atom
        }
    }
}
