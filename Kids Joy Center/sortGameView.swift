//
//  sortGameView.swift
//  Kids Joy Center
//
//  Created by Jay Guan on 3/26/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import UIKit

class sortGameView: UIView {
    
    var time: UIImageView!
    var score: UIImageView!
    var background: UIImageView!
    var timeLabel: UILabel!
    var scoreLabel: UILabel!
    var topView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        
        // add background
        background = UIImageView(frame: CGRect.zero)
        background.image = UIImage(named: "air-land-water")
        background.frame = CGRect(x:0,y:176,width:1024, height: 592)
        self.addSubview(background)
        
        // add timer
        time = UIImageView(frame: CGRect.zero)
        time.image = UIImage(named: "time")
        time.frame = CGRect(x:0,y:718, width:140, height: 40)
        self.addSubview(time)
        
        //add time labels
        timeLabel = UILabel(frame: CGRect.zero)
        timeLabel.frame = CGRect(x:140,y:718, width:140, height: 40)
        timeLabel.font = timeLabel.font.withSize(25)
        timeLabel.backgroundColor = UIColor.lightGray
        self.addSubview(timeLabel)
        
        
        // add score
        score = UIImageView(frame: CGRect.zero)
        score.image = UIImage(named: "score")
        score.frame = CGRect(x:750,y:718, width:160, height: 40)
        self.addSubview(score)
        
        // score numbers
        //add time labels
        scoreLabel = UILabel(frame: CGRect.zero)
        scoreLabel.frame = CGRect(x:910,y:718, width:100, height: 40)
        scoreLabel.font = scoreLabel.font.withSize(25)
        scoreLabel.backgroundColor = UIColor.lightGray
        scoreLabel.text = "0"
        self.addSubview(scoreLabel)
        
        //add top view
        topView = UIView(frame: CGRect.zero)
        topView.frame = CGRect(x:0,y:56,width:1024, height: 120)
        topView.backgroundColor = UIColor.init(red: 51/255, green: 222/255, blue: 255/255, alpha: 1)
        self.addSubview(topView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cleanUp() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}
