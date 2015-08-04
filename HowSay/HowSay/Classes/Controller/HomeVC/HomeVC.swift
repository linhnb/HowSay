//
//  HomeVC.swift
//  HowSay
//
//  Created by asiantech on 7/23/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit
import CoreData


class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AddNewCellDelegate, UICollectionViewDelegateFlowLayout, AddViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate {
    var identifier1 = "cell1"
    var identifier2 = "cell2"
    
    var coverView: UIView = UIView()
    var mainScreen: CGRect = CGRect()
    var addView = AddView()
    var actionSheet = UIActionSheet()
     var chooseImage = UIImage()
    let imagePicker:UIImagePickerController? = UIImagePickerController()
    var listSelecteds = [WordObject]()
    var numberOfCell = 0
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var words = [WordObject]()
    var wordManagedObjects = [NSManagedObject]()
    
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
        playButton.hidden = true
        deleteButton.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
    }
    override func shouldAutorotate() -> Bool {
        return false
    }
    func loadData() {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Word")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            wordManagedObjects = results
            self.parseDataFromArray(wordManagedObjects)
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    func parseDataFromArray (arrayWord: NSArray) {
        words.removeAll(keepCapacity: true)
        for item in arrayWord {
            var keyWord = ""
            var image = ""
            var audio = ""
            if (item.valueForKey("keyword") != nil) {
                keyWord = item.valueForKey("keyword") as! String
            }
            
            if (item.valueForKey("image") != nil) {
                image = item.valueForKey("image") as! String
            }
            
            if (item.valueForKey("audio") != nil){
                audio = item.valueForKey("audio") as! String
            }
            
            //let audioData: NSData = item.valueForKey("audio") as! NSData
            
            let word = WordObject()
            word.keyword = keyWord
            word.image = image//UIImage(data: imageData)!
            word.audio = audio
            words.append(word)
        }
    }
    
    func parseDataFromObject(#item: NSManagedObject) -> WordObject {
        let word: WordObject = WordObject()
        
        var keyWord = ""
        var image = ""
        var audio = ""
        if (item.valueForKey("keyword") != nil) {
            keyWord = item.valueForKey("keyword") as! String
        }
        
        if (item.valueForKey("image") != nil) {
            image = item.valueForKey("image") as! String
        }
        
        if (item.valueForKey("audio") != nil){
            audio = item.valueForKey("audio") as! String
        }
        //let audioData: NSData = item.valueForKey("audio") as! NSData
        
        word.keyword = keyWord
        word.image = image//UIImage(data: imageData)!
        word.audio = audio
        return word
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    //MARK: - button Action.
    
    @IBAction func touchDelete(sender: AnyObject) {
        self.removeWordFromCoreData(wordDeletes: listSelecteds)
    }
    @IBAction func touchPlay(sender: AnyObject) {
        let detail = DetailVC(nibName: "DetailVC", bundle: nil)
        detail.listSelecteds = listSelecteds
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func removeWordFromCoreData(#wordDeletes: [WordObject]) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.managedObjectContext!
        
        var i = 0
        for(i = 0; i < wordDeletes.count ; i++) {
            var isChange = false
            let wordDelete = wordDeletes[i]
            var j = 0
            for (j = 0; j < wordManagedObjects.count; j++) {
                let word =  self.parseDataFromObject(item: wordManagedObjects[j] )
                if( (wordDelete.keyword == word.keyword) && (wordDelete.image == word.image) && (word.audio == wordDelete.audio)) {
                    managedContext.deleteObject(wordManagedObjects[i])
                    var savingError: NSError?
                    if managedContext.save(&savingError){
                        println("Successfully saved the context")
                        isChange = true
                    } else {
                        if let error = savingError{
                            println("Failed to save the context. Error = \(error)")
                        }
                    }
                }
                if((i == wordDeletes.count - 1) && (isChange == true)) {
                    self.loadData()
                    homeCollectionView.reloadData()
                    playButton.hidden = true
                    deleteButton.hidden = true
                }
            }
            
        }
        
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

}

//MARK: - UICollectionViewDelegate

extension HomeVC {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfCell = words.count + 1
        return numberOfCell
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if (indexPath.item == numberOfCell - 1){
             let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier2, forIndexPath: indexPath) as! AddNewCell
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier1, forIndexPath: indexPath) as! HomeCell
            
            let word = words[indexPath.row]
            cell.word = word
            // checked items
            
            if(contains(listSelecteds, cell.word!)) {
                cell.setHidenChecked(false)
            } else {
                cell.setHidenChecked(true)
            }
//            if findObject(indexPath.item) {
//                cell.setHidenChecked(false)
//            } else {
//                cell.setHidenChecked(true)
//            }
            return cell
        }
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView .cellForItemAtIndexPath(indexPath) as! HomeCell
        
        if (contains(listSelecteds, cell.word!)) {
            var i = 0
            for (i = 0; i < listSelecteds.count; i++) {
                let word = listSelecteds[i] as WordObject
                if (word == cell.word) {
                    listSelecteds.removeAtIndex(i)
                    cell.setHidenChecked(true)
                    if listSelecteds.count == 0 {
                        playButton.hidden = true
                        deleteButton.hidden = true
                    }
                }
            }
        } else {
            listSelecteds.append(cell.word!)
            cell.setHidenChecked(false)
            playButton.hidden = false
            deleteButton.hidden = false
        }
        if(listSelecteds.count == 0) {
            playButton.hidden = true
            deleteButton.hidden = true
        }
    }
    

}

//MARK: - UIpickerControllerDelegate
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


extension UINavigationController {
    public override func supportedInterfaceOrientations() -> Int {
        return visibleViewController.supportedInterfaceOrientations()
    }
    public override func shouldAutorotate() -> Bool {
        return visibleViewController.shouldAutorotate()
    }
}

extension UITabBarController {
    public override func supportedInterfaceOrientations() -> Int {
        if let selected = selectedViewController {
            return selected.supportedInterfaceOrientations()
        }
        return super.supportedInterfaceOrientations()
    }
    public override func shouldAutorotate() -> Bool {
        if let selected = selectedViewController {
            return selected.shouldAutorotate()
        }
        return super.shouldAutorotate()
    }
}





