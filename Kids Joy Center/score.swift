//
//  score.swift
//  Kids Joy Center
//
//  Created by Jay Guan on 3/28/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import Foundation

class score: NSObject, NSCoding {
    var order = 0
    var gameType = ""
    var level = ""
    var score = 0
    init(order:Int, gameType: String, level:String, score:Int) {
        self.order = order
        self.gameType = gameType
        self.level = level
        self.score = score
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(order, forKey: "order")
        aCoder.encode(gameType, forKey: "gameType")
        aCoder.encode(level, forKey:"level")
        aCoder.encode(score, forKey:"score")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(order:0, gameType: "", level:"", score:0)
        if let order = aDecoder.decodeObject(forKey: "order") as? Int
        {
            self.order = order
        }
        if let gameType = aDecoder.decodeObject(forKey: "gameType") as? String
        {
            self.gameType = gameType
        }
        if let level = aDecoder.decodeObject(forKey: "level") as? String
        {
            self.level = level
        }
        if let score = aDecoder.decodeObject(forKey: "score") as? Int
        {
            self.score = score
        }
        
    }
}
