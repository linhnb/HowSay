//
//  AddNewVC.swift
//  HowSay
//
//  Created by asiantech on 7/23/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit

class AddNewVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var viewImageItemImage: UIImageView!
    @IBOutlet weak var viewImageBackGroundImage: UIImageView!
    @IBOutlet weak var viewImageButton: UIButton!
    @IBOutlet weak var keyWordTextFiled: UITextField!
    @IBOutlet weak var microButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var detailView: UIView!

    
    var constaintDetailFrame: CGRect? = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewImageItemImage.backgroundColor = UIColor.whiteColor()
        viewImageItemImage.layer.cornerRadius = viewImageItemImage.frame.size.height/2
        viewImageButton.layer.cornerRadius = viewImageButton.frame.size.height/2
        
        
        constaintDetailFrame = detailView.frame
        // Do any additional setup after loading the view.
        
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchChooseImage(sender: AnyObject) {
        detailView.frame = constaintDetailFrame!
    }
    @IBAction func touchDone(sender: AnyObject) {
        detailView.frame = constaintDetailFrame!
        let root = HomeVC(nibName: "HomeVC", bundle: nil)
        self.navigationController?.pushViewController(root, animated: false)
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
    

}
