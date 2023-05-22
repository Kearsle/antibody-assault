//
//  GameViewController.swift
//  Mobile Application 2
//
//  Created by Daniel Kearsley-Brown on 30/04/2023.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the default top left back button
        navigationItem.hidesBackButton = true
        
        // Create game scene
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        if skView.scene == nil {
            scene.scaleMode = .resizeFill
            scene.viewController = self
            skView.ignoresSiblingOrder = true
            skView.presentScene(scene)
        }
    }
    
    func gameEnded(gameScore: Int) {
        // Set the global score variable
        appDelegate.gameModel.setScore(score: gameScore)
        // move to end screen view
        performSegue(withIdentifier: "gameToEndScreen", sender: self)
        // stop running view
        dismiss(animated: false)
    }
}
