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
    
    override func awakeFromNib() {
        imvImage.layer.cornerRadius = imvImage.frame.height/2
        imvImage.layer.borderColor = UIColor.whiteColor().CGColor
        imvImage.layer.borderWidth = 2
    }

    
    @IBAction func namePlay(sender: AnyObject) {
        print("Play Audio")
    }

}
