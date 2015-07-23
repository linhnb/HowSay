//
//  CircleImage.swift
//  HowSay
//
//  Created by asiantech on 7/23/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit

class CircleImage: UIView {
    @IBOutlet weak var imageViewBackGround: UIImageView?
    @IBOutlet weak var imageViewItem: UIImageView?
    
//    @IBInspectable var image: UIImage? {
//        get {
//            return imageViewItem!.image
//        }
//        set(image) {
//            imageViewItem!.image = image
//        }
//    }
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()

    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        
    }
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CircleImage", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! CircleImage
        return view
    }
    
    override func awakeFromNib() {
        
    }
    
}
