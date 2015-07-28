//
//  HomeVC.swift
//  HowSay
//
//  Created by asiantech on 7/23/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AddNewCellDelegate, UICollectionViewDelegateFlowLayout {
    var identifier1 = "cell1"
    var identifier2 = "cell2"
    
    var coverView: UIView = UIView()
    var mainScreen: CGRect = CGRect()
    var addView = UIView()
    @IBOutlet weak var homeCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadViewBegin()
    }
    
    func loadViewBegin() {
        let nibNameNormal  = UINib(nibName: "HomeCell", bundle: nil)
        homeCollectionView.registerNib(nibNameNormal, forCellWithReuseIdentifier: identifier1)
        let nibNameAdd = UINib(nibName: "AddNewCell", bundle: nil)
        homeCollectionView.registerNib(nibNameAdd, forCellWithReuseIdentifier: identifier2)
        
        
        mainScreen = UIScreen.mainScreen().bounds
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK:- addNewCell Delegate
    func addNewCellDelegatePushToAddView() {
        let rootVC = AddNewVC(nibName: "AddNewVC", bundle: nil)
        self.navigationController?.pushViewController(rootVC, animated: false)
    }
    
    func addNewCellDelegateAddCoverView() {
//        coverView = UIView(frame: CGRectMake(mainScreen.size.width/6, mainScreen.size.height/6, 2 * mainScreen.size.width/3, 2 * mainScreen.size.height/3))
//        coverView.backgroundColor = UIColor.lightGrayColor()
//        coverView.alpha = 0.7
//        self.addTapGestureTo(view: coverView)
//        self.addTapGestureTo(view: self.view)
//        self.view.addSubview(coverView)
//        coverView.center = self.view.center
        
        
        addView = NSBundle.mainBundle().loadNibNamed("AddView", owner: self, options: nil)[0] as! UIView
        
        
        //coverView = UIView(frame: CGRectMake(addView.frame.origin.x - 20, addView.frame.origin.y - 20, addView.frame.size.width + 40 , addView.frame.size.height + 40 ))
        coverView = UIView(frame: mainScreen)
            
        coverView.backgroundColor = UIColor.whiteColor()
        coverView.alpha = 0.7
        self.addTapGestureTo(view: coverView)
        self.addTapGestureTo(view: self.view)
        
        
        self.view.addSubview(coverView)
        coverView.center = self.view.center
        
        self.view.addSubview(addView)
        addView.center = self.view.center

    }
    
    
    
    //MARK: - dismisCoverView
    func dismisCoverView (){
        addView.hidden = true
        coverView.hidden = true
        
    }
    
    func addTapGestureTo(#view: UIView) {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismisCoverView")
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
}

//MARK: - UICollectionViewDelegate

extension HomeVC {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if (indexPath.item == 19){
             let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier2, forIndexPath: indexPath) as! AddNewCell
            cell.delegate = self
            return cell
        } else {
             let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier1, forIndexPath: indexPath) as! HomeCell
            return cell
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detail = DetailVC(nibName: "DetailVC", bundle: nil)
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let heightSize = (collectionView.frame.size.height - 50)/2
//        let size = CGSizeMake(heightSize, heightSize)
//        
//        return size
//    }

}
