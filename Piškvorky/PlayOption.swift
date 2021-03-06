//
//  PlayOption.swift
//  Piškvorky
//
//  Created by Adam Salih on 06/06/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import UIKit

class PlayOption: UIViewController, WindowManager {
    @IBOutlet weak var exitingLobyButton: UIButton!
    @IBOutlet weak var newLobyButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //button dimension
    let buttonWidth = 305 as CGFloat!
    let buttonHeight = 55 as CGFloat!
    
    //place in view for buttons
    var exitingOrigin:CGRect!
    var newOrigin:CGRect!
    var backOrigin:CGRect!
    var stredX:CGFloat!
    
    //connection vars
    var reachability:Reachability!
    var waitingForConnection = true
    var connected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.mainScreen().bounds
        self.view.backgroundColor = UIColor.clearColor()
        
        self.stredX = (UIScreen.mainScreen().bounds.width / 2) - (buttonWidth / 2)
        let screenH = UIScreen.mainScreen().bounds.height
        self.exitingOrigin  =   CGRect(x: self.stredX, y: (screenH / 2) - (self.buttonHeight + 10), width: self.buttonWidth, height: self.buttonHeight)
        self.newOrigin      =   CGRect(x: self.stredX, y: (screenH / 2) + 10, width: self.buttonWidth, height: self.buttonHeight)
        self.backOrigin =       CGRect(x: self.stredX, y: (UIScreen.mainScreen().bounds.height) - (1*(self.buttonHeight + 20)), width: self.buttonWidth, height: self.buttonHeight)
        
        func buttonSetUp(#button:UIButton, origin: CGRect){
            button.backgroundColor = lighBlue
            button.tintColor = UIColor.blackColor()
            button.layer.cornerRadius = self.buttonHeight / 2
            button.frame = origin
        }
        
        buttonSetUp(button: self.exitingLobyButton, exitingOrigin)
        buttonSetUp(button: self.newLobyButton, self.newOrigin)
        buttonSetUp(button: self.backButton, self.backOrigin)
        self.checkNetwork()
    }
    
    func checkNetwork(){
        self.reachability = Reachability(hostname: "http://google.com")
        if self.reachability.startNotifier(){
            self.connected = true
            self.waitingForConnection = false
        }else{
            self.waitingForConnection = false
            let alert = UIAlertView()
            alert.title = "Chyba sítě"
            alert.message = "Buď chceš hrát online piškvorky bez internetu, nebo je něco se serverem"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    //MARK: - Button Methods
    
    @IBAction func connectToLoby(sender: AnyObject) {
        if self.isConnected(){
            let loby = ChooseLoby()
            self.animate(CreateLobyButton: order.first, JoinLobyButton: order.second, BackButton: order.third, smer: Smer.doleva, view: loby)
        }
    }
    
    @IBAction func createNewLoby(sender: AnyObject) {
        if isConnected(){
            let newLoby = NewLoby()
            self.animate(CreateLobyButton: order.second, JoinLobyButton: order.first, BackButton: order.third, smer: Smer.doleva, view: newLoby)
        }
    }
    
    @IBAction func goBack(sender: AnyObject) {
        let menu = MainMenu()
        self.animate(CreateLobyButton: order.third, JoinLobyButton: order.second, BackButton: order.first, smer: Smer.doprava, view: menu)
    }
    
    func isConnected() -> Bool{
        if self.waitingForConnection{
            let alert = UIAlertView()
            alert.title = "kontrola sítě"
            alert.message = "Vydrž, kámo, kontroluju, jestli je server up"
            alert.addButtonWithTitle("OK")
            alert.show()
            return false
        }else{
            if self.connected{
                return true
            }else{
                let alert = UIAlertView()
                alert.title = "Chyba sítě"
                alert.message = "Buď chceš hrát online piškvorky bez internetu, nebo je něco se serverem"
                alert.addButtonWithTitle("OK")
                alert.show()
                return false
            }
        }
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
    
    func animate(CreateLobyButton crt:order, JoinLobyButton join:order, BackButton backButt:order, smer:Smer, view:UIViewController){
        
        //order by order. Heh.
        let creat = (((Double(crt.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        let joint = (((Double(join.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        let back = (((Double(backButt.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        
        var x:CGFloat = 0
        
        if smer == Smer.doleva{
            x = -(self.buttonWidth)
        }else if smer == Smer.doprava{
            x = UIScreen.mainScreen().bounds.width
        }
        
        var poradi = 0
        
        UIView.animateWithDuration(0.2, delay: creat, options: nil, animations: {
            self.exitingLobyButton.frame.origin.x = x
            }, completion: { (bl:Bool) in
                poradi = poradi + 1
                self.changeView(poradi, viewContr: view, direction: smer)
        })
        
        UIView.animateWithDuration(0.2, delay: joint, options: nil, animations: {
            self.newLobyButton.frame.origin.x = x
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
        titleLabel.text = "O n l i n e"
        
        UIView.animateWithDuration(0.6, animations: {
            titleLabel.frame.origin.y = 0
            titleLabel.alpha = 1
        })
        
        UIView.animateWithDuration(0.2, animations: {
            self.exitingLobyButton.frame = self.exitingOrigin
        })
        
        UIView.animateWithDuration(0.2, delay: 0.1, options: nil, animations: {
            self.newLobyButton.frame = self.newOrigin
        }, completion: {(bl:Bool) in})
        
        UIView.animateWithDuration(0.2, delay: 0.3, options: nil, animations: {
            self.backButton.frame = self.backOrigin
        }, completion: {(bl:Bool) in})
        
    }
    
    func windowsObjects() -> [UIView]{
        return [self.exitingLobyButton, self.newLobyButton, self.backButton]
    }
    
    func getView() -> UIView{
        return self.view
    }
    
    override init() {
        super.init(nibName: "PlayOption", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
