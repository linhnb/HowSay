//
//  HomeVC.swift
//  HowSay
//
//  Created by asiantech on 7/23/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AddNewCellDelegate, UICollectionViewDelegateFlowLayout, AddViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate {
    var identifier1 = "cell1"
    var identifier2 = "cell2"
    
    var coverView: UIView = UIView()
    var mainScreen: CGRect = CGRect()
    var addView = AddView()
    var actionSheet = UIActionSheet()
     var chooseImage = UIImage()
    let imagePicker:UIImagePickerController? = UIImagePickerController()
    var addView = UIView()
    var listSelect: NSMutableArray!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadViewBegin()
        imagePicker!.delegate = self
    }
    
    func loadViewBegin() {
        let nibNameNormal  = UINib(nibName: "HomeCell", bundle: nil)
        homeCollectionView.registerNib(nibNameNormal, forCellWithReuseIdentifier: identifier1)
        let nibNameAdd = UINib(nibName: "AddNewCell", bundle: nil)
        homeCollectionView.registerNib(nibNameAdd, forCellWithReuseIdentifier: identifier2)
        mainScreen = UIScreen.mainScreen().bounds
        listSelect = NSMutableArray()
        playButton.hidden = true
        
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
        addView = NSBundle.mainBundle().loadNibNamed("AddView", owner: self, options: nil)[0] as! AddView
        addView.delegate = self

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

    //MARK: - AddviewDelegate
    
    func addViewDelegateDismissAddView() {
         self.dismisCoverView()
    }
    
    func addViewDelegatePresentView(#imagePicker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true
            , completion: { () -> Void in
                self.presentViewController(self.imagePicker!, animated: true, completion: nil)
        })
    }
    
    func addViewDelegateDismissViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func addViewDelegateShowActionSheet() {
         actionSheet = UIActionSheet(title: "Choose Image", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Photo", "Choose From Gallary")
        imagePicker!.delegate = self
        actionSheet.showInView(self.view)
    }

    @IBAction func playTouch(sender: UIButton) {
        let detail = DetailVC(nibName: "DetailVC", bundle: nil)
        self.navigationController?.pushViewController(detail, animated: true)
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
            // checked items
            if findObject(indexPath.item) {
                cell.setHidenChecked(false)
            } else {
                cell.setHidenChecked(true)
            }
            return cell
        }
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView .cellForItemAtIndexPath(indexPath) as! HomeCell
        
        if findObject(indexPath.item) {
            listSelect.removeObject(indexPath.item)
            cell.setHidenChecked(true)
            if listSelect.count == 0 {
                playButton.hidden = true
            }
        } else {
            listSelect.addObject(indexPath.item)
            cell.setHidenChecked(false)
            playButton.hidden = false
        }
        
    }
    

    
}

//MARK: - UIpickerControllerDelegate

    
    func findObject(value: Int)-> Bool {
        var count = listSelect.count
        if count <= 0 {
            return false
        }
        for var i = 0; i < listSelect.count; i++ {
            if (listSelect.objectAtIndex(i) as! Int) == value {
                return true
            }
        }
        return false
    }


extension HomeVC {
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 0) {
            
        }
        
        if (buttonIndex == 1) {
            self.openCamera()
        }
        
        if (buttonIndex == 2) {
            self.openGallary()
        }
    }
    
    func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePicker!.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker!, animated: true, completion: nil)
            
        } else {
            self.openGallary()
        }
    }
    
    func openGallary() {
        //self.presentViewController(imagePicker!, animated: true, completion: nil)
        self.dismissViewControllerAnimated(true
            , completion: { () -> Void in
              self.presentViewController(self.imagePicker!, animated: true, completion: nil)
        })
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            chooseImage = pickerImage
            //iconImage.image = chooseImage
            //chooseImageButton.hidden = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }


}








