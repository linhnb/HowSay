 //
//  DetailVC.swift
//  HowSay
//
//  Created by AsianTech on 7/23/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit

 class DetailVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollContent: UIScrollView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var preButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var viewContent: UIView!
    var position: CGFloat!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        position = 0
        preButton.hidden = true
        scrollContent.delegate = self
        
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
        print("pre touch")
        nextButton.hidden = false
        
        if position < 1 {
            preButton.hidden = true
            return
        }
        position = position - 1
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.scrollContent.contentOffset = CGPoint(x: self.view.frame.size.width * self.position, y: 0)
        })
    }
    @IBAction func playTouch(sender: AnyObject) {
        print("Play Audio")
    }
    @IBAction func nextTouch(sender: AnyObject) {
        print("next touch")
        preButton.hidden = false
        if position > 2 {
            nextButton.hidden = true
            return
        }
        position = position + 1
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.scrollContent.contentOffset = CGPoint(x: self.view.frame.size.width * self.position, y: 0)
        })
    }
    @IBAction func repeatTouch(sender: AnyObject) {
        
    }
    @IBAction func backTouch(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // Scroll View Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        position = scrollView.contentOffset.x / viewContent.frame.size.width
        
        if position == 0 {
            preButton.hidden = true
        }
        if position == 3 {
            nextButton.hidden = true
        }
        if position >= 1 && position <= 2 {
            preButton.hidden = false
            nextButton.hidden = false
        }
    }
    
    

}
