//
//  MenuWindow.swift
//  Piškvorky
//
//  Created by Adam Salih on 03/06/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import UIKit

class MenuWindow: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    var currentWindow:WindowManager!
    
    override init() {
        super.init(nibName: "MenuWindow", bundle: nil)
    }

    override func viewDidLoad() {
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        self.view.backgroundColor = blue
        self.textLabel.frame.origin.x = (UIScreen.mainScreen().bounds.width / 2) - (textLabel.frame.width / 2)
        self.textLabel.frame.origin.y = (UIScreen.mainScreen().bounds.height / 4) - (textLabel.frame.height / 2)
        let notcen = NSNotificationCenter.defaultCenter()
        notcen.addObserver(self, selector: "segue:", name: "segueToAnotherScreen", object: nil)
        let mainMenu = MainMenu()
        notcen.postNotificationName("segueToAnotherScreen", object: mainMenu, userInfo: ["smer":"nahoru"])
    }
    
    func segue(notification:NSNotification){
        UIView.animateWithDuration(0.6, animations: {
            self.textLabel.alpha = 0
        })
        let window = notification.object as WindowManager
        self.view.addSubview(window.getView())
        self.currentWindow = window
        let dic = notification.userInfo as [String:String]
        if dic["color"] == "white"{
            self.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        }else{
            UIView.animateWithDuration(0.5, animations: {
                self.view.backgroundColor = blue
            })
            self.prepareForAppear(windows: window.windowsObjects(), smer: dic["smer"]!)
        }
        window.makeAppear(titleLabel: self.textLabel)
    }
    
    func prepareForAppear(#windows:[UIView], smer: String){
        if smer == "nahoru"{
            for view in windows{
                view.frame.origin.y = UIScreen.mainScreen().bounds.height
            }
        }else if smer == "dolu"{
            for view in windows{
                view.frame.origin.y = -(view.frame.height)
            }
        }else if smer == "doleva"{
            for view in windows{
                view.frame.origin.x = UIScreen.mainScreen().bounds.width
            }
        }else if smer == "doprava"{
            for view in windows{
                view.frame.origin.x = -(view.frame.width)
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

@objc protocol WindowManager {
    func makeAppear(#titleLabel:UILabel)
    func windowsObjects() -> [UIView]
    func getView() -> UIView
}