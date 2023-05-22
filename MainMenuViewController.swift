//
//  MainMenuViewController.swift
//  Mobile Application 2
//
//  Created by Daniel Kearsley-Brown on 30/04/2023.
//

import UIKit

class MainMenuViewController : UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
        // Play Level 1
    @IBAction func Level1Handler(_ sender: Any) {
        // Set difficulty global variable
        appDelegate.gameModel.setLevel(level: 1)
        // Move to game view
        performSegue(withIdentifier: "playGame", sender: self)
    }
    
    // Play Level 2
    @IBAction func Level2Handler(_ sender: Any) {
        // Set difficulty global variable
        appDelegate.gameModel.setLevel(level: 2)
        // Move to game view
        performSegue(withIdentifier: "playGame", sender: self)
    }
    
    // Play Level 3
    @IBAction func Level3Handler(_ sender: Any) {
        // Set difficulty global variable
        appDelegate.gameModel.setLevel(level: 3)
        // Move to game view
        performSegue(withIdentifier: "playGame", sender: self)
    }
}
