//
//  SettingsViewController.swift
//  TengoGengo
//
//  Created by Merwan Rodriguez on 2/13/16.
//  Copyright © 2016 Merwan Rodriguez. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {

    @IBOutlet weak var gameTypeControl: UISegmentedControl!
    @IBOutlet weak var difficultyControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    
    var delegate: SettingsViewDelegate!
    var selectedType: String!
    var selectedDifficulty: String!
    
    convenience init(delegate:SettingsViewDelegate) {
        self.init()
        self.delegate = delegate;
    }

// MARK - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        gameTypeControl.selectedSegmentIndex = self.selectedType == "Katakana" ? 0 : 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // for later... might have to subclass a uiview so i can drawRect and make a circle just like the atomViews
//    override func viewDidAppear(animated: Bool) {
//        view.layer.cornerRadius = view.frame.size.width / 2
//        view.layer.backgroundColor = UIColor.whiteColor().CGColor
//        view.layer.borderColor = UIColor.redColor().CGColor
//        view.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
//
//    }
    
// MARK - Overrides

    @IBAction func selectType(sender: UISegmentedControl) {
        selectedType = sender.selectedSegmentIndex == 0 ? "Katakana" : "Hiragana";
    }
    
    @IBAction func selectDifficulty(sender: AnyObject) {
        //let selectedDifficulty:String = sender.selectedSegmentIndex == 0 ? "easy" : "normal";
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        delegate.setKey!("h")
        delegate.setType!(selectedType);
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    
    
/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("hello");
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
*/
}

// MARK - Delegate Declaration

@objc protocol SettingsViewDelegate {
    func startNewGame()
    optional func setKey(key: String)
    optional func setType(type: String)
    optional func setDifficulty(difficulty: String)
    
}
