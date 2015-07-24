//
//  AddNewCell.swift
//  HowSay
//
//  Created by asiantech on 7/23/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit

protocol AddNewCellDelegate {
    func addNewCellDelegatePushToAddView();
}


class AddNewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var imageViewBackground: UIImageView!
    
    var delegate: AddNewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        // Initialization code
        imageViewItem.layer.borderWidth = 2.0
        imageViewItem.layer.borderColor = UIColor.whiteColor().CGColor
        imageViewItem.layer.cornerRadius = imageViewItem.bounds.size.height/2
        print(imageViewItem.bounds.size.height)
        imageViewItem.clipsToBounds = true
    }
    
    @IBAction func touchAddNew(sender: AnyObject) {
        if (UIUserInterfaceIdiom.Pad == UI_USER_INTERFACE_IDIOM()){
            
        } else {
            self.delegate?.addNewCellDelegatePushToAddView()
        }
    }

}
