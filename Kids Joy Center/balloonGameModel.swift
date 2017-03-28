//
//  balloonGameModel.swift
//  Kids Joy Center
//
//  Created by Jay Guan on 3/27/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import Foundation

class balloonGameModel {
    
    init() {
        
    }
    // returns size of image and spacing
    func imgSpacing(imgNum: Int, imgSize:Int)->Int {
        // 10 for gaps of imgs
        var total = imgNum*imgSize
        var gap = 1024 - total
        gap = gap/(imgNum-1)
        return gap
    }
}
