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
    @IBOutlet weak var checkedImage: UIImageView!
    var word: Word? {
        willSet {
            //itemImage.image = newValue.valueForKey("image")
            //let imageData = newValue?.image //newValue!.valueForKey("image") as! NSData
            //let image = //UIImage(data: imageData)
            let imageString = newValue?.image
            let image = UIImage(contentsOfFile: imageString!)
            //itemImage.image = newValue?.image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backGroundImage.layer.cornerRadius = backGroundImage.frame.size.height/2
        itemImage.layer.cornerRadius = itemImage.frame.size.height/2
        itemImage.layer.borderWidth = 2.0
        itemImage.layer.borderColor = UIColor.whiteColor().CGColor
        checkedImage.hidden = true
        // Initialization code
    }
    
    func setHidenChecked(hidden: Bool) {
        checkedImage.hidden = hidden;
    }
}
