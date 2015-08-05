//
//  AddView.swift
//  HowSay
//
//  Created by asiantech on 7/23/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

protocol AddViewDelegate {
    func addViewDelegateDismissAddView()
    func addViewDelegatePresentView(#imagePicker: UIImagePickerController)
    func addViewDelegateDismissViewController()
    func addViewDelegateShowActionSheet()
    func addViewDelegateRecord(#isSelected: Bool)
    func addViewDelegateDidFinishSave()
}
class AddView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, AVAudioRecorderDelegate, UIAlertViewDelegate {

    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var keyWordTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var imageViewImage: UIImageView!
    
    
    var imageFileURL: NSURL!
    var imageFilePath: String!
    var currentFileNameImage: String!

    var soundFileURL: NSURL!
    var soundFilePath: String!
    var currentFileNameRecord: String!
    var recorder: AVAudioRecorder!
    
    var caseAlertSelected = 0
    var isChoosenImage = false
    
    var delegate: AddViewDelegate?
    var chooseImage = UIImage()
    var actionSheet = UIActionSheet()
    let imagePicker = UIImagePickerController()
    override func awakeFromNib() {
        actionSheet = UIActionSheet(title: "Choose Image", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Photo", "Choose From Gallary")
        imagePicker.delegate = self
        iconImage.layer.cornerRadius = iconImage.frame.size.width/2
        iconImage.clipsToBounds = true
        imageViewImage.layer.cornerRadius = imageViewImage.frame.size.width/2
        imageViewImage.clipsToBounds = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handlerNotification:", name: "HomeVCDidChooseImage", object: nil)
    }
    
    
    func handlerNotification(notification: NSNotification) {
        let dict: NSDictionary = notification.userInfo!
        chooseImage = dict.objectForKey("image") as! UIImage
        isChoosenImage = true
        print(chooseImage.size.height)
    }
    
    //MARK: - button Action
    @IBAction func touchBack(sender: AnyObject) {
        self.delegate?.addViewDelegateDismissAddView()
    }

    @IBAction func touchDone(sender: AnyObject) {
        //
        if (count(keyWordTextField.text) == 0){
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
            word.setValue(keyWordTextField.text, forKey: "keyword")
            word.setValue(currentFileNameImage, forKey: "image")
            word.setValue(currentFileNameRecord, forKey: "audio")
            
            //4
            var error: NSError?
            if (!managedContext.save(&error)) {
                print("Save error\(error)")
                ShowStatus().showStatus(status: "error", cancelButton: "", inTime: 0.5)
            } else {
                
               ShowStatus().showStatus(status: "success", cancelButton: "", inTime: 0.5)
            }
            self.dismissKeyBoard()
            self.delegate?.addViewDelegateDismissAddView()
            
        }
    }
    func dismissKeyBoard() {
        keyWordTextField.resignFirstResponder()
        self.endEditing(true)
    }
    @IBAction func touchRecord(sender: AnyObject) {
        recordButton.selected = !recordButton.selected
        //self.delegate?.addViewDelegateeRecord(isSelected: recordButton.selected)
        print("Record/n")
        
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
        actionSheet.showInView(self)
        //self.delegate?.addViewDelegateShowActionSheet()
    }
    
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
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch(caseAlertSelected) {
        case 1:
            keyWordTextField.becomeFirstResponder()
            break
            
        case 2:
            self.touchChooseImage(chooseImageButton)
            break
            
        case 3:
            break
            
        default:
            break
        }
    }
    //MARK: - Record
    
    func startRecord() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        currentFileNameRecord = "recording" + formatter.stringFromDate(currentDateTime)+".wav"
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
    
    // MARK: - UIpickerViewDelegate
    func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            //self.presentViewController(imagePicker, animated: true, completion: nil)
            self.delegate?.addViewDelegatePresentView(imagePicker: imagePicker)
        } else {
            self.openGallary()
        }
    }
    
    func openGallary() {
        self.delegate?.addViewDelegatePresentView(imagePicker: imagePicker)
        //self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
//            chooseImage = pickerImage
//            iconImage.image = chooseImage
//            chooseImageButton.hidden = true
//        }
//        //dismissViewControllerAnimated(true, completion: nil)
//        self.delegate?.addViewDelegateDismissViewController()
//    }
//    
//    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        //dismissViewControllerAnimated(true, completion: nil)
//        self.delegate?.addViewDelegateDismissViewController()
//    }
    
    // MARK: - saveData
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
