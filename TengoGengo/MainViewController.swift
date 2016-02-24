//
//  ViewController.swift
//  TengoGengo
//
//  Created by Merwan Rodriguez on 12/19/15.
//  Copyright © 2015 Merwan Rodriguez. All rights reserved.
//

import UIKit
@IBDesignable
class MainViewController: UIViewController, SettingsViewDelegate {
    @IBOutlet weak var gameContentView: UIView!
    @IBOutlet weak var gameControlsBar: UIToolbar!
    

    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    
    var runningGame: MoleculeView!
    var selectedType = "Katakana"
    var selectedKey = "h"
    
    
// MARK - overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        startNewGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK - helpers 

    
// MARK - actions
    @IBAction func reload() {
        runningGame.reload();
    }
    
    @IBAction func nextSet() {
        runningGame.nextSet()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("hello");
        let settingsController = (segue.destinationViewController as! SettingsViewController)
        settingsController.selectedType = self.selectedType
        settingsController.delegate = self;
        
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }

    
// MARK - SettingsViewDelegate
    func startNewGame() {
        runningGame = MoleculeView(gameView: gameContentView, key: selectedKey, type: selectedType);
    }
    
    func setKey(key: String) {
        selectedKey = key
    }
    
    func setType(type: String) {
        selectedType = type
    }
}