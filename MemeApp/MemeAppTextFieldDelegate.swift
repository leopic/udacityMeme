//
//  MemeAppTextFieldDelegate.swift
//  MemeApp
//
//  Created by Leo Picado on 7/26/15.
//  Copyright (c) 2015 LeoPicado. All rights reserved.
//

import Foundation
import UIKit

class MemeAppTextFieldDelegate: NSObject, UITextFieldDelegate {

    let textAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -4.0
    ]
    let textAlignment = NSTextAlignment.Center
    var previousText:String!

    // Hide keyboard upon hitting return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Store and clean the placeholder values before the user tapped into the textfield
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" {
            previousText = "TOP"
            textField.text = ""
        }
        if textField.text == "BOTTOM" {
            previousText = "BOTTOM"
            textField.text = ""
        }
    }

    // If the textfield is clean, set it back to the placeholder text
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text.isEmpty {
            textField.text = previousText
        }
    }

}
