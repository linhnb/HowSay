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
    
    var listSelecteds = [Word]()
    var listAudio = [String]()
    var player: AVPlayer!
    @IBOutlet weak var viewContent: UIView!
    var position: Int!
    

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
            self.scrollContent.contentOffset = CGPoint(x: self.view.frame.size.width * CGFloat( self.position), y: 0)
        })
    }
    func playerDidFinishPlaying() {
        playButton.selected = false
    }
    @IBAction func playTouch(sender: AnyObject) {
        playButton.selected = !playButton.selected
        
        print("Play Audio")
        let audioString = listAudio[position]
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask    = NSSearchPathDomainMask.UserDomainMask
        if let paths            = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory,nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    let readPath = dirPath.stringByAppendingPathComponent(audioString)
                    let audioURL = NSURL(fileURLWithPath: readPath)
                    player = AVPlayer(URL: audioURL)
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
                    player.play()
                }
            }
        }
    }
    @IBAction func nextTouch(sender: AnyObject) {
        print("next touch")
        preButton.hidden = false
        if position > 1 {
            nextButton.hidden = true
            return
        }
        position = position + 1
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.scrollContent.contentOffset = CGPoint(x: self.view.frame.size.width * CGFloat( self.position), y: 0)
        })
    }
    @IBAction func repeatTouch(sender: AnyObject) {
        
    }
    @IBAction func backTouch(sender: AnyObject) {
        let home = HomeVC(nibName: "HomeVC", bundle: nil)
        self.navigationController?.pushViewController(home, animated: false)
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    // Scroll View Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        position = Int (scrollView.contentOffset.x / viewContent.frame.size.width)
        
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
