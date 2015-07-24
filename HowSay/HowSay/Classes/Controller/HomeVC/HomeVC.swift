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
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    func addNewCellDelegatePushToAddView() {
        let rootVC = AddNewVC(nibName: "AddNewVC", bundle: nil)
        self.navigationController?.pushViewController(rootVC, animated: false)
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
