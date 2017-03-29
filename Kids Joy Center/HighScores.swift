//
//  HighScores.swift
//  Kids Joy Center
//
//  Created by Jay Guan on 3/28/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import Foundation

class HighScores :NSObject, NSCoding {
    var top5 = [score]()
    
    func updateScore(newScore:score) {
        if top5.count == 5 {
            //if score list is full
            let minScore = findMinScore()
            if top5[minScore].score < newScore.score {
                newScore.order = minScore
                top5[minScore] = newScore
            }
        }
        else {
            // if nothing in the score list
            newScore.order = 0
            top5.append(newScore)
        }
    }
    
    //return index of min score
    func findMinScore()->Int {
        var minIndex = 0
        var minScore = top5[0].score
        var i = 0
        for each in top5 {
            if each.score < minScore {
                minScore = each.score
                minIndex = i
            }
            i+=1
        }
        return minIndex
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(top5, forKey: "top5")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        if let highScores = aDecoder.decodeObject(forKey: "highScores") as? [score]
        {
            self.top5 = highScores
        }
    }
}
