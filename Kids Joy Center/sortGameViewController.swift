//
//  sortGameViewController.swift
//  Kids Joy Center
//
//  Created by Jay Guan on 3/22/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import UIKit
import AVFoundation

class sortGameViewController: UIViewController {
    var superView: sortGameView!
    var cheerPlayer = AVAudioPlayer()
    var timeCount = 0
    var timer: Timer? = nil
    var difficulty = ""
    var lastFound = 0
    var scoreNum = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let audioPath = Bundle.main.path(forResource: "cheer", ofType: "mp3")
        
        do{
            cheerPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        }
        catch{
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Sorting Game"
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backAction))
        self.navigationItem.leftBarButtonItem = newBackButton
        superView = sortGameView(frame: CGRect.zero)
        self.view.addSubview(superView)
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.updateTime),
                                     userInfo: nil,
                                     repeats: true)
        setTimer()
    }
    
    func backAction() {
        timer?.invalidate()
        timer = nil
        performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    func setTimer() {
        switch difficulty {
        case "easy":
            timeCount = 60
        case "medium":
            timeCount = 45
        case "hard":
            timeCount = 30
        default:
            60
        }
    }
    
    func updateTime() {
        timeCount-=1
        lastFound+=1
        //update frame
        let minutes = getMinutes(seconds: timeCount)
        let seconds = getSeconds(seconds: timeCount)
        print("Minutes: \(minutes) Seconds: \(seconds)")
        superView.timeLabel.text = "\(minutes):\(seconds)"
        if (minutes == 0 && seconds == 0) {
            stop()
            lost()
        }
    }
    
    func getMinutes(seconds:Int) -> Int{
        return seconds/60
    }
    
    func getSeconds(seconds:Int)->Int {
        return seconds%60
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func lost() {
        let alert = UIAlertController(title: "You Lost", message: "Do you want to play again?", preferredStyle: .alert)
        
        let no = UIAlertAction(title: "No", style: .default, handler:
            {
                (alert: UIAlertAction!) in self.NoHandler()
        })
        
        let yes = UIAlertAction(title: "Yes", style: .default, handler:
            {
                (alert: UIAlertAction!) in self.YesHandler()
        })
        
        
        alert.addAction(no)
        alert.addAction(yes)
        
        present(alert, animated: true, completion: nil)
    }
    
    func won() {
        let alert = UIAlertController(title: "You Won", message: "Do you want to play again?", preferredStyle: .alert)
        
        let no = UIAlertAction(title: "No", style: .default, handler:
            {
                (alert: UIAlertAction!) in self.NoHandler()
        })
        
        let yes = UIAlertAction(title: "Yes", style: .default, handler:
            {
                (alert: UIAlertAction!) in self.YesHandler()
        })
        
        
        alert.addAction(no)
        alert.addAction(yes)
        
        present(alert, animated: true, completion: nil)
        
        //TODO update top 5 score if necessary
    }
    func YesHandler() {
        print("yes pressed")
        initVariables()
        self.viewWillAppear(false)
    }
    
    func NoHandler() {
        backAction()
    }
    
    func updateScore() {
        superView.scoreLabel.text = "\(scoreNum)"
    }
    
    func initVariables() {
        stop()
        timeCount = 0
        timer = nil
        lastFound = 0
        scoreNum = 0
    }
}
