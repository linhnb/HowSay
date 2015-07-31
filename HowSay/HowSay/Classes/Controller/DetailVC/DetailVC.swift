 //
//  DetailVC.swift
//  HowSay
//
//  Created by AsianTech on 7/23/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit
import AVFoundation
 
 class DetailVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollContent: UIScrollView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var preButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var listSelecteds = [Word]()
    var listAudio = [String]()
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
        scrollContent.contentSize = CGSize(width: CGFloat (self.view.frame.size.width * CGFloat(( listSelecteds.count ))), height: viewContent.frame.size.height)
        for var i = 0; i <  listSelecteds.count ; i++ {
            var detail: Detail!
            detail = NSBundle.mainBundle().loadNibNamed("Detail", owner: self, options: nil)[0] as! Detail
            detail.frame = CGRect(x: CGFloat (self.view.frame.size.width * CGFloat( i )), y: CGFloat(0), width: CGFloat(viewContent.frame.size.width), height: CGFloat(viewContent.frame.size.height))
            let word: Word = listSelecteds[i] as Word
            detail.word = word
            listAudio.append(word.audio)
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
        let audioString = listAudio[0]
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let name = defaults.URLForKey("audio")
        
        let audioURL = NSURL(fileURLWithPath: audioString)
        
        let urlPlay = "/Users/asiantech/Library/Developer/CoreSimulator/Devices/3727F222-AA36-4A0C-9FBC-C43391838785/data/Containers/Data/Application/0E34A577-756B-4A72-A575-68FBCE12D25D/Documents/recording-2015-07-30-16-56-46.m4a"
        var url = NSURL(string: urlPlay)
        var player = AVPlayer(URL: url)
        player.play()
        //"/Users/asiantech/Library/Developer/CoreSimulator/Devices/3727F222-AA36-4A0C-9FBC-C43391838785/data/Containers/Data/Application/6F457C00-18C0-4640-A1AD-186E2E6EEDAE/Documents/recording-2015-07-30-15-59-48.m4a"
        //"/Users/asiantech/Library/Developer/CoreSimulator/Devices/3727F222-AA36-4A0C-9FBC-C43391838785/data/Containers/Data/Application/E2B35408-0EA1-4D68-B468-0E2D807F8CAF/Documents/recording-2015-07-30-15-59-44.m4a"
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
