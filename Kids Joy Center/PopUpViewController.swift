//
//  PopUpViewController.swift
//  Kids Joy Center
//
//  Created by Jay Guan on 3/28/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    @IBOutlet weak var label1: UILabel!

    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var label5: UILabel!
   
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
