//
//  AddView.swift
//  HowSay
//
//  Created by asiantech on 7/23/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit

protocol AddViewDelegate {
    func addViewDelegateDismissAddView()
    func addViewDelegatePresentView(#imagePicker: UIImagePickerController)
    func addViewDelegateDismissViewController()
    func addViewDelegateShowActionSheet()
}
class AddView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {

    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var keyWordTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!

    var delegate: AddViewDelegate?
    var chooseImage = UIImage()
    var actionSheet = UIActionSheet()
    let imagePicker = UIImagePickerController()
    override func awakeFromNib() {
        actionSheet = UIActionSheet(title: "Choose Image", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Photo", "Choose From Gallary")
        imagePicker.delegate = self
    }
    
    
    //MARK: - button Action
    @IBAction func touchBack(sender: AnyObject) {
        self.delegate?.addViewDelegateDismissAddView()
    }

    @IBAction func touchDone(sender: AnyObject) {
        self.delegate?.addViewDelegateDismissAddView()
    }
    
    @IBAction func touchRecord(sender: AnyObject) {
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            chooseImage = pickerImage
            iconImage.image = chooseImage
            chooseImageButton.hidden = true
        }
        //dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.addViewDelegateDismissViewController()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.addViewDelegateDismissViewController()
    }
    
}
