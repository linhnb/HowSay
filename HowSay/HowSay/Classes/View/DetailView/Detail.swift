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
                            imvImage.image = image
                        }
                    }
            }
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
