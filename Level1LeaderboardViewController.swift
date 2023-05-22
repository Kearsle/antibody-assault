//
//  LeaderboardViewController.swift
//  Mobile Application 2
//
//  Created by Daniel Kearsley-Brown on 01/05/2023.
//

import UIKit

class Level1LeaderboardViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    let tableCellIdentifier = "tableCellIdentifier"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Number of rows needed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.leaderboardModel.getLevel1SavedScores().count
    }
    
    // Build table rows containing the custom table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath as IndexPath) as! LeaderboardTableViewCell
        
        // Set text for labels within the cell
        let savedScores = appDelegate.leaderboardModel.getLevel1SavedScores()
        cell.textUsername?.text = savedScores[indexPath.row].getUsername()
        cell.textScore?.text = String(savedScores[indexPath.row].getScore())
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Refresh the table model from saved file
        appDelegate.leaderboardModel.refreshLevel1SavedScores()
    }
}
