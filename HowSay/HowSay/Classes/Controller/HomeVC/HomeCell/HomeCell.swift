//
//  HomeCell.swift
//  HowSay
//
//  Created by asiantech on 7/23/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var backGroundImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backGroundImage.layer.cornerRadius = backGroundImage.frame.size.height/2
        itemImage.layer.cornerRadius = itemImage.frame.size.height/2
        itemImage.layer.borderWidth = 2.0
        itemImage.layer.borderColor = UIColor.whiteColor().CGColor
        // Initialization code
    }
    

}
