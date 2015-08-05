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
    
}
class PlayDetailView: UIView, UIScrollViewDelegate {

    @IBOutlet weak var scrollContent: UIScrollView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var preButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var viewContent: UIView!
    
    
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
}
