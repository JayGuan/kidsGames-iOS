//
//  memoryGameModel.swift
//  Kids Joy Center
//
//  Created by Jay Guan on 3/22/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import Foundation

class memoryGameModel {
    var imgIndex = [[Int]]()
    
    init(columnNum: Int) {
        var imgCount = [Int](repeating: 0, count: 11)
        for i in 0...3 {
            //each row
            var row = [Int]()
            //index is image name, value is count
            for k in 0..<columnNum {
                var filled = false
                while(!filled) {
                    //get random image names 1-10
                    let rand = Int(arc4random_uniform(10)) + 1
                    //avoid having too many new imgs
                    if(imgCount[rand] == 0) {
                        let uniqueImgNum=sumOfIndexWithValues(array: imgCount)
                        
                        //if we can still add new images
                        if uniqueImgNum < 2*columnNum {
                            imgCount[rand]+=1
                            row.insert(rand, at: k)
                            filled = true
                        }
                    }
                    //img was added, but cannot be added more than 2 times
                    else if (imgCount[rand]<2) {
                        imgCount[rand]+=1
                        row.insert(rand, at: k)
                        filled = true
                    }
                }
            }
            imgIndex.append(row)
        }
    }
    
    func sumOfIndexWithValues(array:[Int]) -> Int{
        var sum = 0
        for each in array {
            if each > 0 {
                sum+=1
            }
        }
        return sum
    }
}
