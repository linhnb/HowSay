//
//  AddNewVC.swift
//  HowSay
//
//  Created by asiantech on 7/23/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class AddNewVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, AVAudioRecorderDelegate, UIAlertViewDelegate {

    @IBOutlet weak var viewImageItemImage: UIImageView!
    @IBOutlet weak var viewImageBackGroundImage: UIImageView!
    @IBOutlet weak var viewImageButton: UIButton!
    @IBOutlet weak var keyWordTextFiled: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var detailView: UIView!
    
    
    
    var imageFileURL: NSURL!
    var imageFilePath: String!
    var currentFileNameImage: String!
    
    var soundFileURL: NSURL!
    var soundFilePath: String!
    var currentFileNameRecord: String!
    var recorder: AVAudioRecorder!
    
    var actionSheet = UIActionSheet()
    var chooseImage = UIImage()
    var constaintDetailFrame: CGRect? = CGRect()
    let imagePicker = UIImagePickerController()
    
    var caseAlertSelected = 0
    var isChoosenImage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        viewImageButton.hidden = false
        viewImageItemImage.backgroundColor = UIColor.whiteColor()
        viewImageItemImage.layer.cornerRadius = viewImageItemImage.frame.size.height/2
        viewImageItemImage.clipsToBounds = true
        viewImageButton.layer.cornerRadius = viewImageButton.frame.size.height/2
        
        
        self.registerForKeyboardNotifications()
        
        actionSheet = UIActionSheet(title: "Choose Image", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles:"Take Photo", "Choose From Gallary")
        recordButton.selected = false
        imagePicker.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        constaintDetailFrame = detailView.frame
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func supportedInterfaceOrientations() -> Int {
//        return Int(UIInterfaceOrientation.PortraitUpsideDown.rawValue)
//    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    //MARK: - record
    func startRecord() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        currentFileNameRecord = "recording-" + formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, currentFileNameRecord]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        recorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        recorder.delegate = self
        recorder.meteringEnabled = true;
        recorder.prepareToRecord()
        recorder.record()

    }
    
    func endRecord() {
        print("end record")
        recorder.stop()
        print(soundFileURL)
    }
    
    //MARK: - Action button.
    @IBAction func touchRecord(sender: AnyObject) {
        print("Touch Record")
        recordButton.selected = !recordButton.selected
        
        var audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioSession.setActive(true, error: nil)
        if(recordButton.selected == true) {
            self.startRecord()
        } else {
            self.endRecord()
        }
        
    }
    @IBAction func touchChooseImage(sender: AnyObject) {
        //detailView.frame = constaintDetailFrame!
        
        actionSheet.showInView(self.view)
    }
    func choosenImage() {
        
    }
    @IBAction func touchDone(sender: AnyObject) {
        //detailView.frame = constaintDetailFrame!
        
        if (count(keyWordTextFiled.text) == 0){
            let alert = UIAlertView(title: "", message: "Please enter keyword.", delegate: self, cancelButtonTitle: "OK")
            alert.delegate = self
            alert.show()
            caseAlertSelected = 1
        } else if (isChoosenImage == false){
            let alert = UIAlertView(title: "", message: "Please choose image.", delegate: self, cancelButtonTitle: "OK")
            alert.delegate = self
            alert.show()
            caseAlertSelected = 2
        } else if (currentFileNameRecord == nil){
            let alert = UIAlertView(title: "", message: "Please record keyword.", delegate: self, cancelButtonTitle: "OK")
            alert.delegate = self
            alert.show()
            caseAlertSelected = 3
        } else {
            // save image.
            self.saveImage()
            //1
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            
            //2
            let entity = NSEntityDescription.entityForName("Word", inManagedObjectContext: managedContext)
            let word = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            
            //3
            //if (keyWordTextFiled.text != nil) {
                word.setValue(keyWordTextFiled.text, forKey: "keyword")
            //} else {
               // word.setValue(" ", forKey: "keyword")
           // }
           // if (currentFileNameImage != nil) {
                word.setValue(currentFileNameImage, forKey: "image")
           // } else {
                //word.setValue(" ", forKey: "image")
           // }
            //if (currentFileNameRecord != nil) {
                word.setValue(currentFileNameRecord, forKey: "audio")
           // } else {
               // word.setValue(" ", forKey: "audio")
            //}
            
            
            //word.setValue(chooseImage, forKey: "image")
            //4
            var error: NSError?
            if (!managedContext.save(&error)) {
                print("Save error\(error)")
            }
            
            let root = HomeVC(nibName: "HomeVC", bundle: nil)
            self.navigationController?.pushViewController(root, animated: false)
        }
       
    }
    
    @IBAction func touchBack(sender: AnyObject) {
        if(recordButton.selected == true) {
            let alert = UIAlertView(title: "Oop", message: "Turn off record.", delegate: self, cancelButtonTitle: "OK")
            alert.delegate = self
            alert.show()
        } else {
            self.navigationController?.popViewControllerAnimated(false)
        }
        
    }
    // Keyborad notification.
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShow:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func keyboardWasShow(aNotification: NSNotification) {
        let info: NSDictionary = aNotification.userInfo!
        let kbSize: CGSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue().size
        
        detailView.layoutIfNeeded()
        detailView.setTranslatesAutoresizingMaskIntoConstraints(true)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            var frame = self.detailView.frame;
            frame.origin.y -= kbSize.height
            self.detailView.frame = frame
        })
        

    }
    
    func keyboardWillBeHidden(aNotification: NSNotification) {
        detailView.layoutIfNeeded()
        detailView.setTranslatesAutoresizingMaskIntoConstraints(true)
        keyWordTextFiled.resignFirstResponder()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.detailView.frame = self.constaintDetailFrame!
            self.detailView.setTranslatesAutoresizingMaskIntoConstraints(false)
        })
        detailView.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    //MARK: - Textfield delegate.
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            var frame = self.detailView.frame;
            frame.origin.y -= 216
            self.detailView.frame = frame
        })
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        detailView.layoutIfNeeded()
        detailView.setTranslatesAutoresizingMaskIntoConstraints(true)
        keyWordTextFiled.resignFirstResponder()
        //detailView.frame = constaintDetailFrame!
        detailView.setTranslatesAutoresizingMaskIntoConstraints(false)
        return true
    }
    
    
    //MARK: - ActionSheet Delegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        //cancel
        if(buttonIndex == actionSheet.cancelButtonIndex){
            
        }
        //takePhoto
        if(buttonIndex == 1){
            self.openCamera()
        }
        //choose Library
        if(buttonIndex == 2){
            self.openGallary()
        }
    }
    
    func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            self.openGallary()
        }
    }
    
    func openGallary () {
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch(caseAlertSelected) {
            case 1:
                self.keyWordTextFiled.becomeFirstResponder()
                break
            case 2:
                self.touchChooseImage(viewImageButton)
                break
            case 3:
            break
        default:
            break
        }
    }
}

// MARK: - UIImgaePickerController
extension AddNewVC {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            chooseImage = pickerImage
            viewImageItemImage.image = chooseImage
            viewImageButton.setImage(nil, forState: UIControlState.Normal)
            isChoosenImage = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveImage() {
        var error: NSError?
        var fomat = NSDateFormatter()
        fomat.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        currentFileNameImage = "image-\(fomat.stringFromDate(NSDate())).png"
        print("amilaza1 \(currentFileNameImage)")
        
        var dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var docDir: AnyObject = dirPaths[0]
        imageFilePath = docDir.stringByAppendingPathComponent(currentFileNameImage)
        imageFileURL = NSURL(fileURLWithPath: imageFilePath)
        print("amilaza2 \(imageFilePath)")
        UIImagePNGRepresentation(chooseImage).writeToFile(imageFilePath, atomically: true)
        
    }
}
