//
//  TextFieldDelegate.swift
//  Piškvorky
//
//  Created by Adam Salih on 07/06/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    var viewController:UIViewController!
    var nameField:UITextField!
    var button:UIButton!
    
    init(viewController:UIViewController, textField:UITextField) {
        super.init()
        self.nameField = textField
        self.viewController = viewController
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        self.button = UIButton(frame: UIScreen.mainScreen().bounds)
        self.button.addTarget(self, action: "resign", forControlEvents: UIControlEvents.TouchUpInside)
        viewController.view.addSubview(self.button)
        viewController.view.bringSubviewToFront(self.nameField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        self.resign()
        return false
    }
    
    func resign(){
        self.button.removeFromSuperview()
        self.nameField.resignFirstResponder()
    }
   
}
