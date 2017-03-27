//
//  memoryGameCell.swift
//  Kids Joy Center
//
//  Created by Jay Guan on 3/21/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import UIKit

class memoryGameCell: UICollectionViewCell {
    var cellImg = UIImageView(frame: CGRect.zero)
    var button = UIButton()
    func setButtonImg() {
        button.setImage(self.cellImg.image, for: .normal)
    }
}
