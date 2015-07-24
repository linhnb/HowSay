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
        

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        scrollContent.pagingEnabled = true
        scrollContent.contentSize = CGSize(width: self.view.frame.size.width * 4, height: viewContent.frame.size.height)
        for var i:CGFloat = 0; i < 4; i++ {
            var detail: Detail!
            detail = NSBundle.mainBundle().loadNibNamed("Detail", owner: self, options: nil)[0] as! Detail
            detail.frame = CGRect(x: self.view.frame.size.width * i, y: 0, width: viewContent.frame.size.width, height: viewContent.frame.size.height)
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
