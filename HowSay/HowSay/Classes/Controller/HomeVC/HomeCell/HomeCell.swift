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
    var word: WordObject? {
        willSet {
            var imageString = String()
            
            if (newValue?.image != nil) {
                imageString = newValue!.image
            }
            let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
            let nsUserDomainMask    = NSSearchPathDomainMask.UserDomainMask
            if let paths            = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory,nsUserDomainMask, true) {
                if paths.count > 0 {
                    if let dirPath = paths[0] as? String {
                        let readPath = dirPath.stringByAppendingPathComponent(imageString)
                        let image    = UIImage(contentsOfFile: readPath)
                        itemImage.image = image
                    }
                }
            }
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
