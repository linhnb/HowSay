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
    
//    init(framee: CGRect) {
//        super.init(frame: framee)
//        self.frame = framee
//        NSBundle.mainBundle().loadNibNamed("Detail", owner: self, options: nil)
//        
//    }
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    
    @IBAction func namePlay(sender: AnyObject) {
        print("Play Audio")
    }

}
