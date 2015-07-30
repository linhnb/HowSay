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

class AddNewVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {

    @IBOutlet weak var viewImageItemImage: UIImageView!
    @IBOutlet weak var viewImageBackGroundImage: UIImageView!
    @IBOutlet weak var viewImageButton: UIButton!
    @IBOutlet weak var keyWordTextFiled: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var detailView: UIView!
    
    
    
    var imageFileURL: NSURL!
    var imageFilePath: String!
    
    var soundFileURL: NSURL!
    var recorder: AVAudioRecorder!
    
    var actionSheet = UIActionSheet()
    var chooseImage = UIImage()
    var constaintDetailFrame: CGRect? = CGRect()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewImageButton.hidden = false
        viewImageItemImage.backgroundColor = UIColor.whiteColor()
        viewImageItemImage.layer.cornerRadius = viewImageItemImage.frame.size.height/2
        viewImageButton.layer.cornerRadius = viewImageButton.frame.size.height/2
        
        constaintDetailFrame = detailView.frame
        self.registerForKeyboardNotifications()
        
        actionSheet = UIActionSheet(title: "Choose Image", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles:"Take Photo", "Choose From Gallary")
        recordButton.selected = false
        imagePicker.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func startRecord() {
        print("start record")
        recorder.record()
    }
    
    func endRecord() {
        print("end record")
        recorder.stop()
        print(soundFileURL)
    }
    
    @IBAction func touchRecord(sender: AnyObject) {
        print("Touch Record")
        
        
        var recordSettings:[NSObject: AnyObject] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey : AVAudioQuality.Medium.rawValue,
            AVEncoderBitRateKey : 128000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]
        var error: NSError?
        
        var format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        var currentFileName = "recording-\(format.stringFromDate(NSDate())).m4a"
        println(currentFileName)
        
        var dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var docsDir: AnyObject = dirPaths[0]
        var soundFilePath = docsDir.stringByAppendingPathComponent(currentFileName)
        soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        print(soundFileURL)
        recorder = AVAudioRecorder(URL: soundFileURL!, settings: recordSettings, error: &error)
        
        recorder.prepareToRecord()
        
        recordButton.selected = !recordButton.selected
        if(recordButton.selected == true) {
            self.startRecord()
        } else {
            self.endRecord()
        }
    }
    @IBAction func touchChooseImage(sender: AnyObject) {
        detailView.frame = constaintDetailFrame!
        
        actionSheet.showInView(self.view)
        
    }
    @IBAction func touchDone(sender: AnyObject) {
        detailView.frame = constaintDetailFrame!
        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity = NSEntityDescription.entityForName("Word", inManagedObjectContext: managedContext)
        let word = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //3
        word.setValue(keyWordTextFiled.text, forKey: "keyword")
        //let imageData = UIImageJPEGRepresentation(chooseImage, 1.0)
        word.setValue(imageFilePath, forKey: "image")
        //word.setValue(chooseImage, forKey: "image")
        //4 
        var error: NSError?
        if (!managedContext.save(&error)) {
            print("Save error\(error)")
        }
        
        let root = HomeVC(nibName: "HomeVC", bundle: nil)
        self.navigationController?.pushViewController(root, animated: false)
    }
    
    @IBAction func touchBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(false)
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
    

}

// MARK: - UIImgaePickerController
extension AddNewVC {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            chooseImage = pickerImage
            viewImageItemImage.image = chooseImage
            viewImageButton.hidden = true
            self.saveImage()
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
        var currentFileName = "image-\(fomat.stringFromDate(NSDate())).png"
        print(currentFileName)
        
        var dirPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var docDir: AnyObject = dirPaths[0]
        imageFilePath = docDir.stringByAppendingPathComponent(currentFileName)
        imageFileURL = NSURL(fileURLWithPath: imageFilePath)
        print(imageFilePath)
        UIImagePNGRepresentation(chooseImage).writeToFile(imageFilePath, atomically: true)
        
    }
}
