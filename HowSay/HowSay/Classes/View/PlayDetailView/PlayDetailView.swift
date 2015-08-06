//
//  PlayDetailView.swift
//  HowSay
//
//  Created by asiantech on 8/5/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

protocol PlayDetailViewDelegate {
    func playDetailViewDelegateEnableDismiss(#flag: Bool);
}
class PlayDetailView: UIView, UIScrollViewDelegate {

    @IBOutlet weak var scrollContent: UIScrollView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var preButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var viewContent: UIView!
    
    var delegate: PlayDetailViewDelegate?
    var listSelecteds = [WordObject]()
    
    var listObjs = [WordObject]() {
        willSet {
            listSelecteds = newValue
            self.setupScroll()
        }
    }
    var listAudio = [String]()
    var player: AVPlayer!
    var position: Int!
    
    
    override func awakeFromNib() {
        position = 0
        preButton.hidden = true
        scrollContent.delegate = self
        
        if(listSelecteds.count == 1) {
            preButton.hidden = true
            nextButton.hidden = true
        }
        playButton.selected = false
        repeatButton.selected = false
        print(listSelecteds.count)
        print(listObjs.count)
        backButton.hidden = true
    }
    
    func setupScroll() {
        scrollContent.pagingEnabled = true
        scrollContent.contentSize = CGSize(width: CGFloat (self.frame.size.width * CGFloat(( listSelecteds.count ))), height: viewContent.frame.size.height)
        for var i = 0; i <  listSelecteds.count ; i++ {
            var detail: Detail!
            detail = NSBundle.mainBundle().loadNibNamed("Detail", owner: self, options: nil)[0] as! Detail
            detail.frame = CGRect(x: CGFloat (self.frame.size.width * CGFloat( i )), y: CGFloat(0), width: CGFloat(viewContent.frame.size.width), height: CGFloat(viewContent.frame.size.height))
            let word: WordObject = listSelecteds[i] as WordObject
            detail.word = word
            listAudio.append(word.audio)
            scrollContent.addSubview(detail)
        }
    }
    
    //MARK: - Action button.
    
    @IBAction func touchRepeat(sender: AnyObject) {
        repeatButton.selected = !repeatButton.selected
        if(repeatButton.selected == false) {
            nextButton.hidden = false
        } else {
            nextButton.hidden = true
            
        }
    }
    
    @IBAction func touchPreview(sender: AnyObject) {
        print("touch Preview")
        nextButton.hidden = false
        
        if position < 1 {
            preButton.hidden = true
            return
        }
        position = position - 1
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.scrollContent.contentOffset = CGPoint(x: self.frame.size.width * CGFloat( self.position), y: 0)
        })
    }
    
    @IBAction func touchBack(sender: AnyObject) {
    }
    
    @IBAction func touchPlay(sender: AnyObject) {
        self.delegate?.playDetailViewDelegateEnableDismiss(flag: false)
        playButton.selected = !playButton.selected
        
        print("Play Audio \n")
        let audioString = listAudio[position]
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

    @IBAction func touchNext(sender: AnyObject) {
        print("touch Next")
        preButton.hidden = false
        if position > 1 {
            nextButton.hidden = true
            return
        }
        position = position + 1
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.scrollContent.contentOffset = CGPoint(x: self.frame.size.width * CGFloat( self.position), y: 0)
        })
    }
    
    func playerDidFinishPlaying() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        playButton.selected = false
        if(repeatButton.selected == true) {
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "delay", userInfo: nil, repeats: false)
            self.delegate?.playDetailViewDelegateEnableDismiss(flag: false)
        } else {
            self.delegate?.playDetailViewDelegateEnableDismiss(flag: true)
        }
    }
    func delay() {
        self.touchPlay(playButton)
        //nothing in my method
    }
    
    //MARK:- UIScroll
    func scrollViewDidScroll(scrollView: UIScrollView) {
        position = Int (scrollView.contentOffset.x / viewContent.frame.size.width)
        
        if (position == 0) {
            preButton.hidden = true
        }
        if (position == listSelecteds.count - 1) {
            nextButton.hidden = true
        }
        if (position >= 1 && position <= listSelecteds.count - 2) {
            preButton.hidden = false
            nextButton.hidden = false
        }
    }

}
