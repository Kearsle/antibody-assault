//
//  GameOverViewController.swift
//  Mobile Application 2
//
//  Created by Daniel Kearsley-Brown on 01/05/2023.
//

import UIKit

class GameOverViewController : UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var score = 0
    var level = 1
    var isSaved = false
    
    // Labels
    @IBOutlet weak var textSaveError: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    
    // Text Box
    @IBOutlet weak var textboxUsername: UITextField!
    
    // Buttons
    @IBAction func SaveScoreButtonHandler(_ sender: Any) {
        // Saves the score with the username according to the level
        // Check if a username has been entered
        if textboxUsername.text == "" {
            // Username is not entered
            textSaveError.text = "Username cannot be empty."
            textSaveError.isHidden = false
        } else {
            // Username is entered
            // Check to see if the score is saved already
            if isSaved == false {
                // Save the score
                
                // Decide which file determined by the level
                var fileName = ""
                switch level {
                case 1:
                    fileName = "level1Scores"
                case 2:
                    fileName = "level2Scores"
                case 3:
                    fileName = "level3Scores"
                default:
                    // if failure enter in new file for inspection
                    fileName = "failedToLoadScores"
                    print("Failed to load level")
                }
                
                // Get file directory
                let docDirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileUrl = docDirUrl.appendingPathComponent(fileName).appendingPathExtension("txt")
                
                // Get previously saved information
                var savedString = ""
                do {
                    savedString = try String(contentsOf: fileUrl)
                } catch let error as NSError {
                    print("Failed to read file")
                    print(error)
                }
                
                // building score string with previous entries if needed
                var saveScoreString = ""
                if savedString != "" {
                    // If not the first save entry
                    saveScoreString = (savedString + "," + textboxUsername.text! + ":" + String(score))
                } else {
                    // If is the first save entry
                    saveScoreString = (textboxUsername.text! + ":" + String(score))
                }
                // Write String into file
                print(saveScoreString)
                do {
                    // Try writing the build string to the file
                    try saveScoreString.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
                } catch let error as NSError {
                    // If failed print error
                    print("Failed to write to URL")
                    print(error)
                }
                
                // Communicate to the user that it is saved
                textSaveError.text = "Saved!"
                textSaveError.isHidden = false
                isSaved = true
            } else {
                // Attempt save but it has already been saved
                textSaveError.text = "Score has already been saved."
                textSaveError.isHidden = false
            }
        }
    }
    
    @IBAction func BackButtonHandler(_ sender: Any) {
        // Return to main menu button view
        performSegue(withIdentifier: "backToMainMenu", sender: self)
    }
    
    // On Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the default back button
        navigationItem.hidesBackButton = true
        // Hide save information
        textSaveError.isHidden = true
        isSaved = false
        // Get stored score and level from game model
        score  = appDelegate.gameModel.getScore()
        level = appDelegate.gameModel.getLevel()
        // Display the score
        labelScore.text = "Score: " + String(score)
    }
}
