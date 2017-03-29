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
    var imgNum = 0
    var sortGameData = sortGameModel()
    var imgSize = 80
    var testUIVIew: UIView!
    var topImgs = [sortGameObjects]()
    var beginTouchLocation: CGPoint?
    var matchCount = 0
    var highScores = HighScores()
    
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
        self.title = "Sorting Game"
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backAction))
        self.navigationItem.leftBarButtonItem = newBackButton
        superView = sortGameView(frame: CGRect.zero)
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.updateTime),
                                     userInfo: nil,
                                     repeats: true)
        setTimer()
        self.view.addSubview(superView)
        setTopView()
    }
    
    func populateTopImg(imgNum:Int, imgSize:Int, imgGap:Int) {
        sortGameData.populateNames(num: imgNum)
        
        for i in 0..<imgNum {
            let panGes = UIPanGestureRecognizer.init(target: self, action: #selector(viewDidGragged))
            let newImg = UIImageView(frame: CGRect.zero)
            newImg.image = UIImage(named:sortGameData.imgNames[i])
            let x = i*imgSize+i*imgGap
            let y = 56+(120-imgSize)/2
            newImg.frame = CGRect(x:x,y:y,width:imgSize, height: imgSize)
            newImg.isUserInteractionEnabled = true
            newImg.addGestureRecognizer(panGes)
            let string = sortGameData.imgNames[i]
            let firstChar = string[string.startIndex]
            switch firstChar {
            case "1":
                newImg.tag = 1
            case "2":
                newImg.tag = 2
            case "3":
                newImg.tag = 3
            default:
                newImg.tag = 3
            }
            self.view.addSubview(newImg)

            //random images here TODO
            let newObj = sortGameObjects(img: newImg, location:(x,y), category:"TODO")
            topImgs.append(newObj)
 
        }
    }
    
    func viewDidGragged(_sender: UIPanGestureRecognizer) {
        let newPoint = _sender.location(in: self.view)
        let img = _sender.view!
        img.center = newPoint
        print("x: \(newPoint.x) y: \(newPoint.y)")
        if _sender.state == UIGestureRecognizerState.began {
            beginTouchLocation = _sender.location(in: self.view)
        }
        else if _sender.state == UIGestureRecognizerState.ended {
            print("Ended")
            print("x: \(newPoint.x) y: \(newPoint.y)")
            let location = sortGameData.determineLocation(x: Int(newPoint.x), y: Int(newPoint.y))
            print()
            if !(img.tag == Int(location)) {
                print("not match")
                //return it back
                print("\(beginTouchLocation?.x)")
                let spacing = sortGameData.imgSpacing(imgNum: imgNum, imgSize: imgSize)
                let i = sortGameData.determineTopViewLocation(x:Int((self.beginTouchLocation?.x)!), imgSize:imgSize, imgGap:spacing)
                print("\(i)")
                let newX = i*imgSize+i*spacing
                let newY = 56+(120-imgSize)/2
                UIView.animate(withDuration: 2.0, animations: {
                    img.frame = CGRect(x:CGFloat(newX),y:CGFloat(newY),width:img.frame.width,height:img.frame.height)
                    
                })
            }
            else {
                //matched
                matchCount+=1
                // update score
                cheerPlayer.play()
                switch lastFound {
                case 0...2:
                    scoreNum+=5
                case 2...4:
                    scoreNum+=4
                default:
                    scoreNum+=3
                }
                superView.scoreLabel.text = "\(scoreNum)"
                if matchCount == imgNum {
                    print("you win")
                    won()
                }
            }
        }
    }
    
    func setTopView() {
        setImgNum()
        let spacing = sortGameData.imgSpacing(imgNum: imgNum, imgSize: imgSize)
        populateTopImg(imgNum:imgNum, imgSize:imgSize, imgGap:spacing)
    }
    
    func backAction() {
        timer?.invalidate()
        timer = nil
        performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    func setImgNum() {
        switch difficulty {
        case "easy":
            imgNum = 8
        case "medium":
            imgNum = 10
        case "hard":
            imgNum = 12
        default:
            8
        }
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
        let newScore = score(order:0, gameType: "Sorting", level:"\(difficulty)", score:scoreNum)
        highScores.updateScore(newScore: newScore)
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
        imgNum = 0
        sortGameData = sortGameModel()
        imgSize = 80
        topImgs = [sortGameObjects]()
        beginTouchLocation = nil
        matchCount = 0
        stop()
        superView.cleanUp()
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //unwind
        // parepare for next scene
        if segue.identifier == "unwindToMenu" {
            if let dvc = segue.destination as? ViewController {
                print("back to home, TODO pass score")
                dvc.highScores = self.highScores
            }
        }
    }
}
