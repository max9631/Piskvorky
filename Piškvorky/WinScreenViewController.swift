//
//  WinScreenViewController.swift
//  Piškvorky
//
//  Created by Adam Salih on 07/06/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import UIKit

class WinScreenViewController: UIViewController, WindowManager {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    var cross:Bool!

    //button dimension
    let buttonWidth = 305 as CGFloat!
    let buttonHeight = 55 as CGFloat!
    
    //place in view for buttons
    var textOrigin:CGRect!
    var backOrigin:CGRect!
    var stredX:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.mainScreen().bounds
        self.view.backgroundColor = UIColor.clearColor()
        
        self.stredX = (UIScreen.mainScreen().bounds.width / 2) - (buttonWidth / 2)
        let stredT = (UIScreen.mainScreen().bounds.width / 2) - (self.textLabel.frame.width / 2)
        let screenH = UIScreen.mainScreen().bounds.height
        self.textOrigin  =   CGRect(x: stredT, y: (screenH/2) - (self.textLabel.frame.height / 2), width: self.textLabel.frame.width, height: self.textLabel.frame.height)
        self.backOrigin =       CGRect(x: self.stredX, y: (UIScreen.mainScreen().bounds.height) - (1*(self.buttonHeight + 20)), width: self.buttonWidth, height: self.buttonHeight)
        
        if !self.cross{
            self.textLabel.text = "Kroužky vyhrály"
        }
        
        func buttonSetUp(#button:UIButton, origin: CGRect){
            button.backgroundColor = UIColor(red:0.64, green:0.65, blue:0.66, alpha:1)
            button.tintColor = UIColor.blackColor()
            button.layer.cornerRadius = button.frame.height / 2
            button.frame = origin
        }
        
        buttonSetUp(button: self.backButton, self.backOrigin)
    }
    
    //MARK: - Button Methods
    
    @IBAction func goBack(sender: AnyObject) {
        let menu = MainMenu()
        self.animate(winlabel: order.second, BackButton: order.first, smer: Smer.doprava, view: menu)
    }
    
    //MARK: - segue animation
    
    func changeView(poradi:Int, viewContr:UIViewController, direction:Smer){
        if poradi == 2{
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
    
    func animate(winlabel wnlbl:order, BackButton backButt:order, smer:Smer, view:UIViewController){
        
        //order by order. Heh.
        let label = (((Double(wnlbl.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        let back = (((Double(backButt.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        
        var x:CGFloat = 0
        
        if smer == Smer.doleva{
            x = -(self.buttonWidth)
        }else if smer == Smer.doprava{
            x = UIScreen.mainScreen().bounds.width
        }
        
        var poradi = 0
        
        UIView.animateWithDuration(0.2, delay: label, options: nil, animations: {
            self.textLabel.frame.origin.x = x
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
        titleLabel.text = "K o n e c   h r y"
        
        UIView.animateWithDuration(0.6, animations: {
            titleLabel.frame.origin.y = 0
            titleLabel.alpha = 1
        })
        
        UIView.animateWithDuration(0.2, animations: {
            self.textLabel.frame = self.textOrigin
        })
        
        UIView.animateWithDuration(0.2, delay: 0.1, options: nil, animations: {
            self.backButton.frame = self.backOrigin
            }, completion: {(bl:Bool) in})
        
    }
    
    func windowsObjects() -> [UIView]{
        return [self.textLabel, self.backButton]
    }
    
    func getView() -> UIView{
        return self.view
    }
    
    init(cross:Bool) {
        super.init(nibName: "WinScreenViewController", bundle: nil)
        self.cross = cross
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
