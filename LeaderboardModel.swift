//
//  LeaderboardModel.swift
//  Mobile Application 2
//
//  Created by Daniel Kearsley-Brown on 01/05/2023.
//
import UIKit

class LeaderboardModel {
    // Initialise object arrays
    var savedLevel1Scores = [SavedScore]()
    var savedLevel2Scores = [SavedScore]()
    var savedLevel3Scores = [SavedScore]()
    
    // Return level 1 scores in decending order
    open func getLevel1SavedScores() -> [SavedScore] {
        return savedLevel1Scores.sorted {$0.getScore() > $1.getScore()}
    }
    
    // Return level 2 scores in decending order
    open func getLevel2SavedScores() -> [SavedScore] {
        return savedLevel2Scores.sorted {$0.getScore() > $1.getScore()}
    }
    
    // Return level 3 scores in decending order
    open func getLevel3SavedScores() -> [SavedScore] {
        return savedLevel3Scores.sorted {$0.getScore() > $1.getScore()}
    }
    
    // Refresh level 1 saved score array using the save file
    open func refreshLevel1SavedScores() {
        // clear array
        savedLevel1Scores = [SavedScore]()
        // Read file
        let fileName = "level1Scores"
        let docDirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = docDirUrl.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        var scoreString = ""
        do {
            scoreString = try String(contentsOf: fileUrl)
        } catch let error as NSError {
            print("Failed to read file")
            print(error)
        }
        // split the scores
        if scoreString != "" {
            let savedScoresArray = scoreString.components(separatedBy: ",")
            // for each score append score
            for savedScore in savedScoresArray {
                // Split a saved score by the username and score
                let savedScoreArray = savedScore.components(separatedBy: ":")
                let username = savedScoreArray[0]
                let score = Int(savedScoreArray[1]) ?? 0
                savedLevel1Scores.append(SavedScore(username: username, score: score))
            }
        }
    }
    
    // Refresh level 2 saved score array using the save file
    open func refreshLevel2SavedScores() {
        // clear array
        savedLevel2Scores = [SavedScore]()
        // Read file
        let fileName = "level2Scores"
        let docDirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = docDirUrl.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        var scoreString = ""
        do {
            scoreString = try String(contentsOf: fileUrl)
        } catch let error as NSError {
            print("Failed to read file")
            print(error)
        }
        // split the scores
        if scoreString != "" {
            let savedScoresArray = scoreString.components(separatedBy: ",")
            // for each score append score
            for savedScore in savedScoresArray {
                // Split a saved score by the username and score
                let savedScoreArray = savedScore.components(separatedBy: ":")
                let username = savedScoreArray[0]
                let score = Int(savedScoreArray[1]) ?? 0
                savedLevel2Scores.append(SavedScore(username: username, score: score))
            }
        }
    }
    
    // Refresh level 3 saved score array using the save file
    open func refreshLevel3SavedScores() {
        // clear array
        savedLevel3Scores = [SavedScore]()
        // Read file
        let fileName = "level3Scores"
        let docDirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = docDirUrl.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        var scoreString = ""
        do {
            scoreString = try String(contentsOf: fileUrl)
        } catch let error as NSError {
            print("Failed to read file")
            print(error)
        }
        // split the scores
        if scoreString != "" {
            let savedScoresArray = scoreString.components(separatedBy: ",")
            // for each score append score
            for savedScore in savedScoresArray {
                // Split a saved score by the username and score
                let savedScoreArray = savedScore.components(separatedBy: ":")
                let username = savedScoreArray[0]
                let score = Int(savedScoreArray[1]) ?? 0
                savedLevel3Scores.append(SavedScore(username: username, score: score))
            }
        }
    }
}

// Data class containing a saved scores username and score number
class SavedScore {
    private var username: String
    private var score: Int
    
    init(username: String, score: Int) {
        self.username = username
        self.score = score
    }
    
    public func getUsername() -> String {
        return username
    }
    
    public func getScore() -> Int {
        return score
    }
}
