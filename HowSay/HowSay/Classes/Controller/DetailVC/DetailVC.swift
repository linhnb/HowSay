 //
//  DetailVC.swift
//  HowSay
//
//  Created by AsianTech on 7/23/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var scrollContent: UIScrollView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var viewContent: UIView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view.frame.size.width)
        print(self.view.frame.size.height)
        
        scrollContent.pagingEnabled = true
        scrollContent.contentSize = CGSize(width: self.view.frame.size.width * 4, height: viewContent.frame.size.height)
        for var i:CGFloat = 0; i < 4; i++ {
            var detail: Detail!
            print(viewContent.frame.size.width*i)
            detail = NSBundle.mainBundle().loadNibNamed("Detail", owner: self, options: nil)[0] as! Detail
//            switch i {
//            case 1 :
//                detail.frame = CGRectMake(0, 0, self.view.frame.size.width, viewContent.frame.size.height)
//            case 2 :
//                detail.frame = CGRectMake(568, 0, self.view.frame.size.width, viewContent.frame.size.height)
//                break
//            case 3:
//                detail.frame = CGRectMake(viewContent.frame.size.width * i, 0, self.view.frame.size.width, viewContent.frame.size.height)
//                break
//            default :
//                detail.frame = CGRectMake(0, 0, self.view.frame.size.width, viewContent.frame.size.height)
//                break
//            }
            detail.frame = CGRectMake(viewContent.frame.size.width * i, 0, self.view.frame.size.width, viewContent.frame.size.height)
            scrollContent.addSubview(detail)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    @IBAction func preTouch(sender: AnyObject) {
        
    }
    @IBAction func playTouch(sender: AnyObject) {
        
    }
    @IBAction func nextTouch(sender: AnyObject) {
        
    }
    @IBAction func repeatTouch(sender: AnyObject) {
        
    }
    @IBAction func backTouch(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
