//
//  SettingView.swift
//  DropHelper WatchKit Extension
//
//  Created by おいちいたまご on 2021/07/11.
//

import WatchKit
import Foundation

class SettingView: WKInterfaceController {
    @IBOutlet weak var imageAlignmentLeftButton: WKInterfaceButton!
    @IBOutlet weak var imageAlignmentRightButton: WKInterfaceButton!
    
    
    let userDefaults = UserDefaults.standard
    
    var inputData: Int = 0
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        inputData = userDefaults.integer(forKey: KEY_W_IMAGE_ALIGNMENT)
        
        switch inputData {
        case VAL_W_IMAGE_ALIFNMENT_LEFT:
            imageAlignmentLeftButton.setBackgroundColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1))
        case VAL_W_IMAGE_ALIFNMENT_RIGHT:
            imageAlignmentRightButton.setBackgroundColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1))
        default:
            break
        }
        
        
        self.setTitle(NSLocalizedString("WatchOS_Setting", comment: ""))
        
    }
    
    
    @IBAction func imageAlignmentLeftSET() {
        userDefaults.set(VAL_W_IMAGE_ALIFNMENT_LEFT, forKey: KEY_W_IMAGE_ALIGNMENT)
        pop()
    }
    
    
    @IBAction func imageAlignmentRightSET() {
        userDefaults.set(VAL_W_IMAGE_ALIFNMENT_RIGHT, forKey: KEY_W_IMAGE_ALIGNMENT)
        pop()
    }
}
