//
//  MainMenu.swift
//  Piškvorky
//
//  Created by Adam Salih on 11/05/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import UIKit

enum order{
    case first
    case second
    case third
}

class MainMenu: UIViewController, WindowManager {
    //button vars
    @IBOutlet weak var passAndPlayButton: UIButton!
    @IBOutlet weak var OnlineButton: UIButton!
    @IBOutlet weak var SettingsButton: UIButton!
    
    //button dimension
    let buttonWidth = 305 as CGFloat!
    let buttonHeight = 55 as CGFloat!
    
    //place in view for buttons
    var multiplayerOrigin:CGRect!
    var onlineOrigin:CGRect!
    var settingsOrgin:CGRect!
    var stredX:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notcen = NSNotificationCenter.defaultCenter()
        notcen.addObserver(self, selector: "createNewGame", name: "createNewGame", object: nil)
        
        self.view.frame.size.width = UIScreen.mainScreen().bounds.width
        self.view.frame.size.height = UIScreen.mainScreen().bounds.height
        self.view.backgroundColor = UIColor.clearColor()
        
        //setting up constants
        self.stredX = (UIScreen.mainScreen().bounds.width / 2) - (buttonWidth / 2)
        let screenH = UIScreen.mainScreen().bounds.height
        self.multiplayerOrigin  =   CGRect(
                                        x: self.stredX,
                                        y: (screenH / 2) + (0 * (self.buttonHeight + 20)),
                                        width: self.buttonWidth,
                                        height: self.buttonHeight)
        self.onlineOrigin       =   CGRect(
                                        x: self.stredX,
                                        y: (screenH / 2) + (1 * (self.buttonHeight + 20)),
                                        width: self.buttonWidth,
                                        height: self.buttonHeight)
        self.settingsOrgin      =   CGRect(
                                        x: self.stredX,
                                        y: (screenH / 2) + (2 * (self.buttonHeight + 20)),
                                        width: self.buttonWidth,
                                        height: self.buttonHeight)
        
        self.buttonSetUp(button: self.passAndPlayButton, origin: multiplayerOrigin)
        self.buttonSetUp(button: self.OnlineButton, origin: self.onlineOrigin)
        self.buttonSetUp(button: self.SettingsButton, origin: self.settingsOrgin)
    }
    
    func buttonSetUp(#button:UIButton, origin: CGRect){
        button.backgroundColor = lighBlue
        button.tintColor = UIColor.blackColor()
        button.layer.cornerRadius = self.buttonHeight / 2
        button.frame = origin
    }
    
    func makeAppear(#titleLabel:UILabel) {
        
        titleLabel.text = "P I Š K V O R K Y"
        
        UIView.animateWithDuration(0.6, animations: {
            titleLabel.frame.origin.x = (UIScreen.mainScreen().bounds.width / 2) - (titleLabel.frame.width / 2)
            titleLabel.frame.origin.y = (UIScreen.mainScreen().bounds.height / 4) - (titleLabel.frame.height / 2)
            titleLabel.alpha = 1
        })
        
        UIView.animateWithDuration(0.2, animations: {
            self.passAndPlayButton.frame = self.multiplayerOrigin
        })
        
        UIView.animateWithDuration(0.2, delay: 0.1, options: nil, animations: {
            self.OnlineButton.frame = self.onlineOrigin
            }, completion: {(bl:Bool) in})
        
        UIView.animateWithDuration(0.2, delay: 0.3, options: nil, animations: {
            self.SettingsButton.frame = self.settingsOrgin
            }, completion: {(bl:Bool) in})
    }
    
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
    
    func animate(passAndPlay pasy:order, online onln:order, setting stng:order, smer:Smer, view:UIViewController){
        
        //order by order. Heh.
        let pass = (((Double(pasy.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        let online = (((Double(onln.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        let setting = (((Double(stng.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        
        var x:CGFloat = 0
        
        if smer == Smer.doleva{
            x = -(self.buttonWidth)
        }else if smer == Smer.doprava{
            x = UIScreen.mainScreen().bounds.width
        }
        var poradi = 0
        UIView.animateWithDuration(0.2, delay: pass, options: nil, animations: {
            self.passAndPlayButton.frame.origin.x = x
        }, completion: { (bl:Bool) in
            poradi = poradi + 1
            self.changeView(poradi, viewContr: view, direction: smer)
        })
        
        UIView.animateWithDuration(0.2, delay: online, options: nil, animations: {
            self.OnlineButton.frame.origin.x = x
        }, completion: { (bl:Bool) in
            poradi = poradi + 1
            self.changeView(poradi, viewContr: view, direction: smer)
        })
        
        UIView.animateWithDuration(0.2, delay: setting, options: nil, animations: {
            self.SettingsButton.frame.origin.x = x
        }, completion: { (bl:Bool) in
            poradi = poradi + 1
            self.changeView(poradi, viewContr: view, direction: smer)
        })
    }
    
    
    func windowsObjects() -> [UIView] {
        return[self.passAndPlayButton, self.OnlineButton, self.SettingsButton]
    }
    
    func getView() -> UIView {
        return self.view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func newPassAndPlay(sender: AnyObject) {
        let notCenter = NSNotificationCenter.defaultCenter()
        notCenter.postNotificationName("NewGame", object: nil)
    }
    
    @IBAction func newOnline(sender: AnyObject) {
        let documentDirectoryWithoutPlist = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        if NSFileManager.defaultManager().fileExistsAtPath("\(documentDirectoryWithoutPlist[0])/nick.plist") {
            let tmpGrades = NSArray(contentsOfFile: "\(documentDirectoryWithoutPlist[0])/nick.plist")!
            self.startNewGame()
        }else{
            self.newNickName()
        }
    }
    
    func newNickName(){
        let nickNameView = NewNick()
        self.animate(passAndPlay: order.second, online: order.first, setting: order.third, smer: Smer.doleva, view: nickNameView)
    }
    
    func startNewGame(){
        let play = PlayOption()
        self.animate(passAndPlay: order.second, online: order.first, setting: order.third, smer: Smer.doleva, view: play)
    }
    
    @IBAction func settingsPressed(sender: AnyObject) {
        let settings = Settings()
        self.animate(passAndPlay: order.third, online: order.second, setting: order.first, smer: Smer.doprava, view: settings)
    }
    
    override init() {
//        super.init()
        super.init(nibName: "MainMenu", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
