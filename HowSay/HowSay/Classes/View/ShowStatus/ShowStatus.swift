//
//  ShowStatus.swift
//  HowSay
//
//  Created by asiantech on 8/5/15.
//  Copyright (c) 2015 asiantech. All rights reserved.
//

import UIKit

class ShowStatus: NSObject {

    var alert: UIAlertView?
    func showStatus(#status: String, cancelButton: String, inTime: CGFloat) {
        alert = UIAlertView(title: "", message: status, delegate: self, cancelButtonTitle: cancelButton)
        alert!.show()
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(inTime), target: self, selector: "dismissAlert", userInfo: nil, repeats: true)
    }
    
    func dismissAlert() {
        alert!.dismissWithClickedButtonIndex(0, animated: true)
    }
}
