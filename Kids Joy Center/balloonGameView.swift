//
//  balloonGameView.swift
//  Kids Joy Center
//
//  Created by Jay Guan on 3/27/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import UIKit

class balloonGameView: UIView {

    
    var time: UIImageView!
    var score: UIImageView!
    var background: UIImageView!
    var timeLabel: UILabel!
    var scoreLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // add background
        background = UIImageView(frame: CGRect.zero)
        background.image = UIImage(named: "sky-background")
        background.frame = CGRect(x:0,y:0,width:1024, height: 768)
        self.addSubview(background)
        
        // add timer
        time = UIImageView(frame: CGRect.zero)
        time.image = UIImage(named: "time")
        time.frame = CGRect(x:0,y:75, width:140, height: 40)
        self.addSubview(time)
        
        //add time labels
        timeLabel = UILabel(frame: CGRect.zero)
        timeLabel.frame = CGRect(x:140,y:75, width:140, height: 40)
        timeLabel.font = timeLabel.font.withSize(25)
        timeLabel.backgroundColor = UIColor.lightGray
        self.addSubview(timeLabel)
        
        
        // add score
        score = UIImageView(frame: CGRect.zero)
        score.image = UIImage(named: "score")
        score.frame = CGRect(x:750,y:75, width:160, height: 40)
        self.addSubview(score)
        
        // score numbers
        //add time labels
        scoreLabel = UILabel(frame: CGRect.zero)
        scoreLabel.frame = CGRect(x:910,y:75, width:100, height: 40)
        scoreLabel.font = scoreLabel.font.withSize(25)
        scoreLabel.backgroundColor = UIColor.lightGray
        scoreLabel.text = "0"
        self.addSubview(scoreLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
