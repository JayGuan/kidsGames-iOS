//
//  memoryGameViewController.swift
//  Kids Joy Center
//
//  Created by Jay Guan on 3/26/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//
import AVFoundation
import UIKit

class memoryGameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var superView: memoryGameView!
    var test = ""
    var game = ""
    var difficulty = ""
    var collection: UICollectionView!
    let imgSize = 120
    var cellId = "memoryGameCell"
    var columnNum = 0
    var indexes = [[Int]]()
    var imgClickCount = [Int](repeating: 0, count: 11)
    var memoryGameData = memoryGameModel(columnNum: 3)
    var previousClick = (-1,-1)
    var cheerPlayer = AVAudioPlayer()
    var scoreNum = 0
    var totalRevealed = 0
    var top5Score = [Int]()
    var timer: Timer?
    var lastFound = 0
    var timeCount = 0
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
        self.title = "Memory Game"
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backAction))
        self.navigationItem.leftBarButtonItem = newBackButton
        superView = memoryGameView(frame: CGRect.zero)
        columnNum = getColumnNum()
        print("playing \(game)")
        self.view.addSubview(superView)
        createCollectionView(columnNum: columnNum)
        memoryGameData = memoryGameModel(columnNum: columnNum)
        indexes = memoryGameData.imgIndex
        print("total columns \(getColumnNum())")
        setTimer(easy: 120, medium: 105, hard:90)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getColumnNum() -> Int{
        switch difficulty {
        case "easy":
            return 3
        case "medium":
            return 4
        case "hard":
            return 5
        default:
            return 3
        }
    }
    
    
    func createCollectionView(columnNum: Int) {
        // add collection view
        // 145 x 145 per image view, left
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: imgSize, height: imgSize)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        let distanceFromLeft = (1024 - imgSize * columnNum)/2
        let distanceFromTop = (768 - imgSize*4)/2+36 // 36 is half of size of navigation bar
        
        collection.frame = CGRect(x:distanceFromLeft,y:distanceFromTop, width:columnNum*imgSize, height:580)
        collection.dataSource = self
        collection.delegate = self
        collection.register(memoryGameCell.self, forCellWithReuseIdentifier: cellId)
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = UIColor.clear
        
        self.view.addSubview(collection)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getColumnNum()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("row: \(indexPath.section) column: \(indexPath.row)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! memoryGameCell
        cell.cellImg.image = UIImage(named: "question")
        cell.cellImg.frame = CGRect(x:0,y:0,width:imgSize, height: imgSize)
        cell.button.frame = CGRect(x:0,y:0,width:imgSize, height: imgSize)
        cell.setButtonImg()
        cell.button.tag = (indexPath.section*100)+indexPath.row
        cell.button.addTarget(self, action: #selector(buttonFunction), for: .touchUpInside)
        cell.contentView.addSubview(cell.button)
        
        print("cell created")
        return cell
    }
    
    func buttonFunction(sender: UIButton) {
        let section = sender.tag / 100
        let row = sender.tag % 100
        print("button clicked at section[\(section)] row[\(row)]")
        let imgName = indexes[section][row]
        let img = UIImage(named: "\(imgName)")
        sender.setImage(img, for: .normal)
        reloadInputViews()
        //if it is first click
        if previousClick == (-1,-1) {
            previousClick = (row,section)
        } // if previous click matches this click
        else {
            let prevImgName = indexes[previousClick.1][previousClick.0]
            if imgName == prevImgName {
                //play cheer sound
                totalRevealed += 2
                cheerPlayer.play()
                previousClick = (-1,-1)
                switch lastFound {
                case 0..<3:
                    scoreNum += 5
                case 3..<7:
                    scoreNum += 4
                default:
                    scoreNum += 3
                }
                updateScore()
            }
                //if not match, reset to question mark after 1 sec
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    let previousClick = self.previousClick
                    self.changeToQuestion(sender: sender, row: row, section: section, prev: previousClick)
                })
                
            }
        }
        if (totalRevealed == 4*columnNum) {
            //you win
            won()
            if (top5Score.count<5) {
                top5Score.append(scoreNum)
            }
            else {
                // if already has 5 scores
                
            }
        }
    }
    
    func backAction() {
        stop()
        performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    func updateScore() {
        superView.scoreLabel.text = "\(scoreNum)"
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
        let newScore = score(order:0, gameType: "Memory", level:"\(difficulty)", score:scoreNum)
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
    
    func changeToQuestion(sender: UIButton, row: Int, section: Int, prev:(Int,Int)) {
        
        let img = UIImage(named: "question")
        //sender.setImage(img, for: .normal)
        var paths = [IndexPath]()
        
        let path = IndexPath(row: prev.0, section: prev.1)
        let currentPath = IndexPath(row:row, section:section)
        
        print("prev:section[\(prev.1)]row[\(prev.0)]")
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellId, for: path) as! memoryGameCell
        cell.cellImg.image = UIImage(named: "question")
        cell.cellImg.frame = CGRect(x:0,y:0,width:imgSize, height: imgSize)
        cell.button.frame = CGRect(x:0,y:0,width:imgSize, height: imgSize)
        cell.setButtonImg()
        cell.contentView.addSubview(cell.button)
        paths.append(path)
        paths.append(currentPath)
        collection.reloadItems(at: paths)
        previousClick = (-1,-1)
    }
    
    func YesHandler() {
        print("yes pressed")
        initVariables()
        self.viewWillAppear(false)
    }
    
    func NoHandler() {
        backAction()
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
            timer?.invalidate()
            timer = nil
            lost()
        }
    }
    
    func setTimer(easy:Int, medium: Int, hard:Int) {
        
        switch difficulty {
        case "easy":
            timeCount = easy
        case "medium":
            timeCount = medium
        case "hard":
            timeCount = hard
        default:
            timeCount = 120
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.updateTime),
                                     userInfo: nil,
                                     repeats: true)
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
    
    func initVariables() {
        stop()
        test = ""
        game = ""
        difficulty = ""
        indexes = [[Int]]()
        imgClickCount = [Int](repeating: 0, count: 11)
        memoryGameData = memoryGameModel(columnNum: 3)
        previousClick = (-1,-1)
        cheerPlayer = AVAudioPlayer()
        lastFound = 0
        scoreNum = 0
        totalRevealed = 0
        top5Score = [Int]()
        setTimer(easy: 120, medium: 105, hard:90)
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

