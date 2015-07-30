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
            var error: NSError?
            let csvContent = NSString(contentsOfFile: imageString, encoding:NSUTF8StringEncoding, error: &error)
            if csvContent != nil {
                imvImage.image = UIImage(contentsOfFile: imageString)
            }
            else {
                println("error: \(error)")
            }
            
            var dirPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            var docDir: AnyObject = dirPaths[0]
            let path = docDir.stringByAppendingPathComponent("image-2015-07-30-16-54-35.png")
            
            print("ami1:  \(path)")
            print("ami2:  \(imageString)")
            //imvImage.image = UIImage(contentsOfFile: path)
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
