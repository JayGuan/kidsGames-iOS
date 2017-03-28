//
//  balloonGameViewController.swift
//  Kids Joy Center
//
//  Created by Jay Guan on 3/22/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import UIKit
import AVFoundation


class balloonGameViewController: UIViewController {
    var superView: balloonGameView!
    var timeCount = 0
    var timer: Timer? = nil
    var difficulty = ""
    var lastFound = 0
    var scoreNum = 0
    var cheerPlayer = AVAudioPlayer()
    var ballonGameData = balloonGameModel()
    var gates = [Int]()
    var imgSize = 80
    var imgNum = 10
    var slowCountDown = 0
    
    
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
        print("view loaded")
        self.title = "Bursting Balloon"
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backAction))
        self.navigationItem.leftBarButtonItem = newBackButton
        superView = balloonGameView(frame: CGRect.zero)
        populateGates()
        superView.isUserInteractionEnabled = false
        self.view.addSubview(superView)
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.updateTime),
                                     userInfo: nil,
                                     repeats: true)
        setTimer()
        
    }
    
    func populateGates() {
        let spacing = ballonGameData.imgSpacing(imgNum: self.imgNum, imgSize: self.imgSize)
        for i in 0..<self.imgNum {
            gates.append(i*imgSize+i*spacing)
        }
    }
    
    func addSV(speed:Int){
        /*
        // 1024 total screen size,
        var svInfo = random()
        let w = imgSize
        let h = imgSize
        let y = 680
        let x = gates[svInfo.2]
        print("gate \(svInfo.2), ballon Num \(svInfo.0), number \(svInfo.1)")
        let fr = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(w), height: CGFloat(h))
        let view = UIView(frame: fr)
        let balloon = UIImageView(frame: fr)
        let number = UIImageView(frame: fr)
        var imgName = "color\(svInfo.0)"
        var numberName = ""
        
        if svInfo.0 == 11 {
            //11 as star
            imgName = "star"
            number.tag = 2
            balloon.tag = 2
            view.tag = 2
        }
        else if svInfo.0 == 12 {
            //12 as skull
            imgName = "skull"
            number.tag = 3
            balloon.tag = 3
            view.tag = 3
        }
        else {
            number.tag = 1
            balloon.tag = 1
            view.tag = 1
            numberName = "cartoon-number-\(svInfo.1)"
        }
        balloon.image = UIImage(named: imgName)
        balloon.frame = fr
        number.image = UIImage(named: numberName)
        number.frame = CGRect(x: CGFloat(x+imgSize/2), y: CGFloat(y+imgSize/2), width: CGFloat(w/2), height: CGFloat(h/2))
        //number.center = view.center
        number.tag = svInfo.1
        
        //view.addSubview(balloon)
        //view.addSubview(number)
        //view.subviews[0].center = view.center
        //view.subviews[1].center = view.center
        //view.backgroundColor = UIColor.red
        self.view.addSubview(view)
        //animateView(v:balloon, multiplier:speed)
        animateView(v:number, multiplier:speed)
 */
        // 1024 total screen size,
        var svInfo = random()
        let w = imgSize
        let h = imgSize
        let y = 680
        let x = gates[svInfo.2]
        let fr = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(w), height: CGFloat(h))
        var imgName = "color\(svInfo.0)"
        var numberName = ""
        let view = UIView(frame: fr)
        let balloon = UIImageView(frame: CGRect.zero)
        let number = UIImageView(frame: CGRect.zero)
        
        
        if svInfo.0 == 11 {
            //11 as star
            imgName = "star"
            number.tag = 2
            balloon.tag = 2
            view.tag = 2
        }
        else if svInfo.0 == 12 {
            //12 as skull
            imgName = "skull"
            number.tag = 3
            balloon.tag = 3
            view.tag = 3
        }
        else {
            number.tag = 1
            balloon.tag = 1
            view.tag = 1
            numberName = "cartoon-number-\(svInfo.1)"
        }
        
        balloon.image = UIImage(named: imgName)
        balloon.center = view.center
        number.image = UIImage(named: numberName)
        number.center = view.center
        number.frame = CGRect(x:0,y:0,width:h, height: h)
        number.tag = svInfo.1
        print("tag \(number.tag)")
        balloon.frame = CGRect(x:0,y:0,width:h, height: h)
        view.tag = 1

        view.addSubview(balloon)
        view.addSubview(number)
        
        self.view.addSubview(view)
        
        animateView(v:view, multiplier:1)
    }
    
    //returns img name, number name, location index
    func random()-> (Int,Int,Int){
        let location = Int(arc4random_uniform(10))
        let imgName = Int(arc4random_uniform(12))+1
        let numberName = Int(arc4random_uniform(10))
        return (imgName, numberName, location)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self.view)
        var notRemoved = true
        var i = 2
        
        while notRemoved && i < self.view.subviews.count {
            if self.view.subviews[i-1].layer.presentation()!.hitTest(touchLocation) != nil {
                if self.view.subviews[i-1].tag == 2 {
                    print("start clicked")
                    self.view.subviews[i-1].removeFromSuperview()
                    notRemoved = false
                    slowCountDown = 5
                }
                else if self.view.subviews[i-1].tag == 3 {
                    print("skull ckicked")
                    self.view.subviews[i-1].removeFromSuperview()
                    notRemoved = false
                    stop()
                    lost()
                }
                else if self.view.subviews[i-1].tag == 1 {
                    scoreNum += self.view.subviews[i-1].subviews[1].tag
                    self.view.subviews[i-1].removeFromSuperview()
                    notRemoved = false
                    updateScore()
                }
            }
            i+=1
        }
    }
    
    func animateView(v: UIView, multiplier:Int){
        print("animate called")
        var speed = v.frame.origin.y/100 * CGFloat(multiplier)
        switch difficulty {
        case "easy":
            speed = speed*2
        case "medium":
            speed = speed*1.5
        default:
            break
        }
        UIView.animate(withDuration: TimeInterval(speed), delay: 0, options: .allowUserInteraction, animations: {
            v.frame.origin.y = 0
        }, completion: {_ in v.removeFromSuperview() })
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
        if slowCountDown > 0 {
            addSV(speed:2)
            slowCountDown -= 1
        }
        else {
            addSV(speed:1)
        }
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
        timeCount = 0
        lastFound = 0
        scoreNum = 0
        stop()
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
    }

    func backAction() {
        stop()
        performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
}
