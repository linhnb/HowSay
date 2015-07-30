//
//  Detail.swift
//  HowSay
//
//  Created by AsianTech on 7/23/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit

class Detail: UIView {

    @IBOutlet weak var imvImage: UIImageView!
    @IBOutlet weak var btnName: UIButton!
    
    var word: Word? {
        willSet{
            btnName.setTitle(newValue?.keyword, forState: UIControlState.Normal)
            let imageString = newValue?.image
            let imageData = NSData(contentsOfFile:"Documents/image-2015-07-30-14-12-13.png")
            imvImage.image = UIImage(contentsOfFile: imageString!)
            
        }
    }
    override func awakeFromNib() {
        imvImage.layer.cornerRadius = imvImage.frame.height/2
        imvImage.layer.borderColor = UIColor.whiteColor().CGColor
        imvImage.layer.borderWidth = 2
    }

    
    @IBAction func namePlay(sender: AnyObject) {
        print("Play Audio")
    }

}
