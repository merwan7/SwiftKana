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

    override func viewDidLoad() {
        super.viewDidLoad();
        
//        var x: CGFloat;
//        for index in 1...5 {
//            gameContentView.addSubview(atomView(x: x, y: x, syllable: "て", translation: "te"));
//        }
        
        // Do any additional setup after loading the view, typically from a nib.    
        MoleculeView(gameView: self.gameContentView);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

