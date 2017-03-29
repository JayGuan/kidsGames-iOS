//
//  ViewController.swift
//  Kids Joy Center
//
//  Created by Jay Guan on 3/20/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var memoryButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var ballonButton: UIButton!
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    
    // 3 games: memory, sort, balloon
    var selectedGame = ""
    // 3 levels: easy, medium, hard
    var selectedDifficulty = ""
    var highScores = HighScores()
    var x = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var userDefaults = UserDefaults.standard
        /*
        if let decoded  = userDefaults.object(forKey: "highScores") as? Data
        {
            let decodedData = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! HighScores
            highScores = decodedData
            print("decoded")
        }
        */
        
        /*
        for i in 0...4 {
            let newScore = score.init(order: 0, gameType: "Sorting", level: "Difficult", score: i)
            highScores.top5.append(newScore)
        }
 */
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "2") as? String
        {
            print(x)
        }
        
        if let count = UserDefaults.standard.object(forKey: "count") as? Int
        {
            highScores = HighScores()
            for i in 0..<count {
                let newScore = score.init(order: UserDefaults.standard.object(forKey: "order\(i)") as! Int,
                                      gameType: UserDefaults.standard.object(forKey: "gameType\(i)") as! String,
                                      level: UserDefaults.standard.object(forKey: "level\(i)") as! String,
                                      score: UserDefaults.standard.object(forKey: "score\(i)") as! Int)
                highScores.top5.append(newScore)
            }
        }
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        /*
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: highScores)
        userDefaults.set(encodedData, forKey: "highScores")
        userDefaults.synchronize()
 */
        UserDefaults.standard.set("test", forKey: "test2")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func highScoreClicked(_ sender: UIBarButtonItem) {
        //test

            print("adding pop up")
            /*
            let newVC = UIViewController()
            newVC.view.backgroundColor = UIColor.white
            
            newVC.modalPresentationStyle = .popover
            newVC.modalTransitionStyle = .coverVertical
            
            newVC.preferredContentSize = CGSize(width: 300, height: 300)
            */
        let newVC = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "popUpID") as! PopUpViewController
        newVC.view.backgroundColor = UIColor.blue
        newVC.view.center = self.view.center
        self.addChildViewController(newVC)
        let fr = CGRect(x: 150, y: 100, width: 724, height: 500)
        newVC.view.frame = fr
        var i = 0
        for _ in highScores.top5 {
            let score = highScores.top5[i]
            let labelText = "\(i+1) \(score.gameType) \(score.level) \(score.score)"
            i+=1
            switch i {
            case 0:
                newVC.label1.text = labelText
            case 1:
                newVC.label2.text = labelText
            case 2:
                newVC.label3.text = labelText
            case 3:
                newVC.label4.text = labelText
            case 4:
                newVC.label5.text = labelText
            default:
                newVC.label1.text = labelText
            }
        }
        self.view.addSubview(newVC.view)
        newVC.didMove(toParentViewController: self)
        /*
            let fr = CGRect(x: 300, y: 300, width: 300, height: 200)
            let midView = UIView(frame: fr)
            //add time labels
            var label = UILabel(frame: CGRect.zero)
            label.frame = CGRect(x:0,y:100, width:300, height: 40)
            label.font = label.font.withSize(25)
            label.backgroundColor = UIColor.lightGray
            label.isUserInteractionEnabled = false
            midView.addSubview(label)
            midView.backgroundColor = UIColor.red
            self.view.addSubview(midView)
        
            let pop = newVC.popoverPresentationController
            pop?.sourceView = midView
            show(newVC, sender: midView)
 */
    }
    
    
    func ableToPlay()->Bool {
        if ((selectedDifficulty != "") && (selectedGame != "")) {
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func memoryClicked(_ sender: UIButton) {
        selectedGame = "memory"
        //indicate image selected
        memoryButton.alpha = 1
        sortButton.alpha = 0.7
        ballonButton.alpha = 0.7
    }

    @IBAction func sortClicked(_ sender: UIButton) {
        selectedGame = "sort"
        memoryButton.alpha = 0.7
        sortButton.alpha = 1
        ballonButton.alpha = 0.7
    }

    @IBAction func balloonClicked(_ sender: UIButton) {
        selectedGame = "balloon"
        memoryButton.alpha = 0.7
        sortButton.alpha = 0.7
        ballonButton.alpha = 1
    }
    
    @IBAction func easyclicked(_ sender: UIButton) {
        selectedDifficulty = "easy"
        easyButton.alpha = 1
        mediumButton.alpha = 0.7
        hardButton.alpha = 0.7
    }
    
    @IBAction func mediumClicked(_ sender: UIButton) {
        selectedDifficulty = "medium"
        easyButton.alpha = 0.7
        mediumButton.alpha = 1
        hardButton.alpha = 0.7
    }
    
    @IBAction func hardClicked(_ sender: UIButton) {
        selectedDifficulty = "hard"
        easyButton.alpha = 0.7
        mediumButton.alpha = 0.7
        hardButton.alpha = 1
    }
    
    @IBAction func playClicked(_ sender: UIButton) {
        if (ableToPlay()) {
            // play game according to selection, load views
            print("play game \(selectedGame)")
            performSegue(withIdentifier: selectedGame, sender: self)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Please select both game and difficulty level", preferredStyle: .alert)
            
            let myAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alert.addAction(myAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
   @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // parepare for next scene
        if segue.identifier == "memory" {
            
            if let dvc = segue.destination as? memoryGameViewController {
                dvc.game = selectedGame
                dvc.difficulty = selectedDifficulty
                dvc.highScores = self.highScores
                print("entered")
            }
 
        }
        else if segue.identifier == "sort" {
            if let dvc = segue.destination as? sortGameViewController {
                dvc.difficulty = selectedDifficulty
                dvc.highScores = self.highScores
            }
        }
        else if segue.identifier == "balloon" {
            if let dvc = segue.destination as? balloonGameViewController {
                 dvc.difficulty = selectedDifficulty
                 dvc.highScores = self.highScores
                 print("entered")
                
            }
        }
    }
    
}

