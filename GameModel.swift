//
//  ScoreModel.swift
//  Mobile Application 2
//
//  Created by Daniel Kearsley-Brown on 01/05/2023.
//

// Data class to globally store the score and difficulty level
class GameModel {
    var score: Int
    var level: Int
    
    init() {
        score = 0
        level = 1
    }
    
    open func getScore() -> Int {
        return score
    }
    
    open func setScore(score: Int) {
        self.score = score
    }
    
    open func getLevel() -> Int {
        return level
    }
    
    open func setLevel(level: Int) {
        self.level = level
    }
}
