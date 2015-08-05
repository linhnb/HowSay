//
//  HomeVC~ipad.swift
//  HowSay
//
//  Created by asiantech on 7/27/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit

class HomeVC_ipad: UIViewController {

    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    var identifier1 = "cell1"
    var identifier2 = "cell2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadViewBegin()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadViewBegin() {
        let nibNameNormal  = UINib(nibName: "HomeCell", bundle: nil)
        homeCollectionView.registerNib(nibNameNormal, forCellWithReuseIdentifier: identifier1)
        let nibNameAdd = UINib(nibName: "AddNewCell", bundle: nil)
        homeCollectionView.registerNib(nibNameAdd, forCellWithReuseIdentifier: identifier2)

    }
    
    // MARK:- Button Action.
    
    @IBAction func touchPlay(sender: AnyObject) {
        
    }
}
