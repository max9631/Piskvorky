//
//  Settings.swift
//  Piškvorky
//
//  Created by Adam Salih on 17/05/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import UIKit

class Settings: UIViewController, WindowManager {
    @IBOutlet weak var nickField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    var credits:Credits!

    //button dimension
    let buttonWidth = 305 as CGFloat!
    let buttonHeight = 55 as CGFloat!
    
    //place in view for buttons
    var nickOrigin:CGRect!
    var creditOrigin:CGRect!
    var backOrigin:CGRect!
    var stredX:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.credits = Credits()
        self.view.addSubview(self.credits.view)
        self.view.bringSubviewToFront(self.backButton)
        
        let documentDirectoryWithoutPlist = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        if NSFileManager.defaultManager().fileExistsAtPath("\(documentDirectoryWithoutPlist[0])/nick.plist") {
            let nickar = NSArray(contentsOfFile: "\(documentDirectoryWithoutPlist[0])/nick.plist")!
            self.nickField.text = nickar[0] as String
        }
        
        self.view.frame = UIScreen.mainScreen().bounds
        self.view.backgroundColor = UIColor.clearColor()
        
        self.stredX = (UIScreen.mainScreen().bounds.width / 2) - (buttonWidth / 2)
        let stredC = (UIScreen.mainScreen().bounds.width / 2) - (235 / 2)
        let screenH = UIScreen.mainScreen().bounds.height
        
        self.nickOrigin     =   CGRect(x: self.stredX, y: (screenH / 3) , width: self.buttonWidth, height: self.buttonHeight)
        self.creditOrigin   =   CGRect(x: stredC, y: ((screenH / 4) * 3) - (110), width: 235, height: 110)
        self.backOrigin     =   CGRect(x: self.stredX, y: (UIScreen.mainScreen().bounds.height) - (1*(self.buttonHeight + 20)), width: self.buttonWidth, height: self.buttonHeight)
        
        func buttonSetUp(#button:UIButton, origin: CGRect){
            button.backgroundColor = lighBlue
            button.tintColor = UIColor.blackColor()
            button.layer.cornerRadius = self.buttonHeight / 2
            button.frame = origin
        }
        
        buttonSetUp(button: self.backButton, self.backOrigin)
        
        self.nickField.frame = self.nickOrigin
        self.nickField.backgroundColor = lighBlue
        self.dlgt = TextFieldDelegate(viewController: self, textField: self.nickField)
        self.nickField.delegate = self.dlgt
        
        self.credits.view.frame = self.creditOrigin
        self.credits.view.backgroundColor = UIColor.clearColor()
    }
    var dlgt:TextFieldDelegate!
    //MARK: - Button Methods
    
    @IBAction func goBack(sender: AnyObject) {
        if self.nickField.text != ""{
            let ar = NSArray(array: [self.nickField.text])
            let documentDirectoryWithoutPlist = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let filePath = "\(documentDirectoryWithoutPlist[0])/nick.plist"
            ar.writeToFile(filePath, atomically: true)
        }
        let menu = MainMenu()
        self.animate(NickField: order.third, Credits: order.second, BackButton: order.first, smer: Smer.doleva, view: menu)
    }
    
    //MARK: - segue animation
    
    func changeView(poradi:Int, viewContr:UIViewController, direction:Smer){
        if poradi == 3{
            self.view.removeFromSuperview()
            let notcen = NSNotificationCenter.defaultCenter()
            var direct:String
            if direction == Smer.doleva{
                direct = "doleva"
            }else{
                direct = "doprava"
            }
            notcen.postNotificationName("segueToAnotherScreen", object: viewContr, userInfo: ["smer":direct])
        }
    }
    
    func animate(NickField nck:order, Credits crds:order, BackButton backButt:order, smer:Smer, view:UIViewController){
        
        //order by order. Heh.
        let nick = (((Double(nck.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        let credit = (((Double(crds.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        let back = (((Double(backButt.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        
        var x:CGFloat = 0
        
        if smer == Smer.doleva{
            x = -(self.buttonWidth)
        }else if smer == Smer.doprava{
            x = UIScreen.mainScreen().bounds.width
        }
        
        var poradi = 0
        
        UIView.animateWithDuration(0.2, delay: nick, options: nil, animations: {
            self.nickField.frame.origin.x = x
            }, completion: { (bl:Bool) in
                poradi = poradi + 1
                self.changeView(poradi, viewContr: view, direction: smer)
        })
        
        UIView.animateWithDuration(0.2, delay: credit, options: nil, animations: {
            self.credits.view.frame.origin.x = x
            }, completion: { (bl:Bool) in
                poradi = poradi + 1
                self.changeView(poradi, viewContr: view, direction: smer)
        })
        
        UIView.animateWithDuration(0.2, delay: back, options: nil, animations: {
            self.backButton.frame.origin.x = x
            }, completion: { (bl:Bool) in
                poradi = poradi + 1
                self.changeView(poradi, viewContr: view, direction: smer)
        })
    }
    
    //MARK: - Window Manager
    
    func makeAppear(#titleLabel:UILabel){
        titleLabel.text = "N a s t a v e n í"
        
        UIView.animateWithDuration(0.6, animations: {
            titleLabel.frame.origin.y = 0
            titleLabel.alpha = 1
        })
        
        UIView.animateWithDuration(0.2, animations: {
            self.nickField.frame = self.nickOrigin
        })
        
        UIView.animateWithDuration(0.2, delay: 0.1, options: nil, animations: {
            self.credits.view.frame = self.creditOrigin
            }, completion: {(bl:Bool) in})
        
        UIView.animateWithDuration(0.2, delay: 0.3, options: nil, animations: {
            self.backButton.frame = self.backOrigin
            }, completion: {(bl:Bool) in})
        
    }
    
    func windowsObjects() -> [UIView]{
        return [self.nickField, self.credits.view, self.backButton]
    }
    
    func getView() -> UIView{
        return self.view
    }
    
    override init() {
        super.init(nibName: "Settings", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
