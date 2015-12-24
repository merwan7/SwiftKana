//
//  ViewController.swift
//  TengoGengo
//
//  Created by Merwan Rodriguez on 12/19/15.
//  Copyright © 2015 Merwan Rodriguez. All rights reserved.
//

import UIKit
@IBDesignable
class ViewController: UIViewController {
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var gameContentView: UIView!
    @IBOutlet weak var gameControlsBar: UIToolbar!
    
    
    var runningGame: MoleculeView!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var x: CGFloat;
//        for index in 1...5 {
//            gameContentView.addSubview(atomView(x: x, y: x, syllable: "て", translation: "te"));
//        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        runningGame = MoleculeView(gameView: gameContentView, key: "h", type: "Hiragana")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func reload() {
        runningGame.reload();
    }
    
    @IBAction func nextSet() {
        runningGame.nextSet()
    }
}

