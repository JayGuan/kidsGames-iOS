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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                print("entered")
            }
 
        }
        else if segue.identifier == "sort" {
            if let dvc = segue.destination as? sortGameViewController {
                /*
                dvc.game = selectedGame
                dvc.difficulty = selectedDifficulty
                print("entered")
 */
            }
        }
        else if segue.identifier == "sort" {
            if let dvc = segue.destination as? balloonGameViewController {
                /*
                 dvc.game = selectedGame
                 dvc.difficulty = selectedDifficulty
                 print("entered")
                 */
            }
        }
    }
    
}

