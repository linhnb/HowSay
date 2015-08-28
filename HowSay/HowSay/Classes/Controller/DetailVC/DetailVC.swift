 //
//  DetailVC.swift
//  HowSay
//
//  Created by AsianTech on 7/23/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit
import AVFoundation
 
 class DetailVC: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var scrollContent: UIScrollView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var preButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var listSelecteds = [WordObject]()
    var listAudio = [String]()
    var player: AVPlayer!
    @IBOutlet weak var viewContent: UIView!
    var position: Int!
    
    var isAutoPlay = true;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        position = 0
        preButton.hidden = true
        scrollContent.delegate = self
        
        if(listSelecteds.count == 1) {
            preButton.hidden = true
            nextButton.hidden = true
        }
        playButton.selected = false
        repeatButton.selected = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        scrollContent.pagingEnabled = true
        scrollContent.contentSize = CGSize(width: CGFloat (self.view.frame.size.width * CGFloat(( listSelecteds.count ))), height: viewContent.frame.size.height)
        for var i = 0; i <  listSelecteds.count ; i++ {
            var detail: Detail!
            detail = NSBundle.mainBundle().loadNibNamed("Detail", owner: self, options: nil)[0] as! Detail
            detail.frame = CGRect(x: CGFloat (self.view.frame.size.width * CGFloat( i )), y: CGFloat(0), width: CGFloat(viewContent.frame.size.width), height: CGFloat(viewContent.frame.size.height))
            let word: WordObject = listSelecteds[i] as WordObject
            detail.word = word
            listAudio.append(word.audio)
            scrollContent.addSubview(detail)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func shouldAutorotate() -> Bool {
        return  false
    }
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientation.LandscapeRight.rawValue)
    }
    func delay() {
        self.playTouch(playButton)
        //nothing in my method
    }
    //MARK: - Action Button.
    
    @IBAction func preTouch(sender: AnyObject) {
        print("pre touch")
        nextButton.hidden = false
        
        if position < 1 {
            preButton.hidden = true
            return
        }
        position = position - 1
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.scrollContent.contentOffset = CGPoint(x: self.view.frame.size.width * CGFloat( self.position), y: 0)
        })
    }
    func playerDidFinishPlaying() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        // next position
        position = (position == listAudio.count-1) ? 0 : position + 1

        // scroll
        scrollContent.setContentOffset(CGPointMake(scrollContent.frame.size.width * (CGFloat)(position), 0), animated: true)
        
        
        
        playButton.selected = false
        if(repeatButton.selected == true) {
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "delay", userInfo: nil, repeats: false)
            
        }
    }
    @IBAction func playTouch(sender: AnyObject) {
        
        print("Play Audio \n")
        playAudio(position);
    }
    
    func playAudio(index : Int) {
        playButton.selected = !playButton.selected
        let audioString = listAudio[index]
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask    = NSSearchPathDomainMask.UserDomainMask
        if let paths            = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory,nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    let readPath = dirPath.stringByAppendingPathComponent(audioString)
                    let audioURL = NSURL(fileURLWithPath: readPath)
                    player = AVPlayer(URL: audioURL)
                    player.play()
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
                    
                }
            }
        }
        
    }
    
    @IBAction func nextTouch(sender: AnyObject) {
        print("next touch")
        preButton.hidden = false
        if position > 1 {
            nextButton.hidden = false
            //return
        }
        if position == listSelecteds.count - 1 {
            nextButton.hidden = false
        }
        position = position + 1
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.scrollContent.contentOffset = CGPoint(x: self.view.frame.size.width * CGFloat( self.position), y: 0)
        })
    }
    @IBAction func repeatTouch(sender: AnyObject) {
        repeatButton.selected = !repeatButton.selected
        isAutoPlay = !isAutoPlay;
        
//        if(repeatButton.selected == false) {
//            nextButton.hidden = false
//            preButton.hidden = false
//        } else {
//            nextButton.hidden = true
//            preButton.hidden = true
//            
//        }
    }
    @IBAction func backTouch(sender: AnyObject) {
        
        isAutoPlay = false;
        
        let home = HomeVC(nibName: "HomeVC", bundle: nil)
        self.navigationController?.pushViewController(home, animated: false)
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    // Scroll View Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        position = Int (scrollView.contentOffset.x / viewContent.frame.size.width)
        
        if (position == 0) {
            preButton.hidden = true
            nextButton.hidden = true
            if( listSelecteds.count > 1 ){
                nextButton.hidden = false
            }
        }
        if (position == listSelecteds.count - 1) {
            nextButton.hidden = true
            preButton.hidden = true
            if( listSelecteds.count > 1 ){
                preButton.hidden = false
            }
        }
        if (position >= 1 && position <= listSelecteds.count - 2) {
            preButton.hidden = false
            nextButton.hidden = false
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if isAutoPlay {
            playAudio(position)
        }
    }
}
