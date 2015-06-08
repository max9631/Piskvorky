//
//  NewNick.swift
//  Piškvorky
//
//  Created by Adam Salih on 17/05/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import UIKit

class NewNick: UIViewController, WindowManager {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var textFieldOrigin:CGRect!
    var nextOrigin:CGRect!
    var backOrigin:CGRect!
    
    let buttonWidth = 305 as CGFloat!
    let buttonHeight = 55 as CGFloat!
    var stredX:CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.mainScreen().bounds
        self.view.backgroundColor = UIColor.clearColor()
        
        self.stredX = (UIScreen.mainScreen().bounds.width / 2) - (self.buttonWidth / 2)
        
        self.textFieldOrigin =  CGRect(x: self.stredX, y: (UIScreen.mainScreen().bounds.height / 3) - 15, width: self.buttonWidth, height: self.buttonHeight)
        self.nextOrigin =       CGRect(x: self.stredX, y: (UIScreen.mainScreen().bounds.height) - (2*(self.buttonHeight + 20)), width: self.buttonWidth, height: self.buttonHeight)
        self.backOrigin =       CGRect(x: self.stredX, y: (UIScreen.mainScreen().bounds.height) - (1*(self.buttonHeight + 20)), width: self.buttonWidth, height: self.buttonHeight)
        
        self.buttonSetUp(button: self.nextButton, origin: self.nextOrigin)
        self.buttonSetUp(button: self.backButton, origin: self.backOrigin)
        
        self.nameTextField.backgroundColor = lighBlue
        self.nameTextField.frame = self.textFieldOrigin
        self.txtfldlgt = TextFieldDelegate(viewController: self, textField: self.nameTextField)
        self.nameTextField.delegate = self.txtfldlgt
    }
    var txtfldlgt:TextFieldDelegate!
    
    func buttonSetUp(#button:UIButton, origin:CGRect){
        button.backgroundColor = lighBlue
        button.tintColor = UIColor.blackColor()
        button.layer.cornerRadius = self.buttonHeight / 2
        button.frame = origin
    }
    
    //MARK: - Button methods
    
    @IBAction func goBack(sender: AnyObject) {
        let mainMenu = MainMenu()
        self.animate(NameTextField: order.third, NextButton: order.second, BackButton: order.first, smer: Smer.doprava, view: mainMenu)
    }
    
    @IBAction func goNext(sender: AnyObject) {
        if self.nameTextField.text == ""{
            let alert = UIAlertView()
            alert.title = "Prázdné pole"
            alert.message = "Bez jména to nepůjde, kámo"
            alert.addButtonWithTitle("OK")
            alert.show()
        }else{
            let ar = NSArray(array: [self.nameTextField.text])
            let documentDirectoryWithoutPlist = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let filePath = "\(documentDirectoryWithoutPlist[0])/nick.plist"
            ar.writeToFile(filePath, atomically: true)
            let play = PlayOption()
            self.animate(NameTextField: order.second, NextButton: order.first, BackButton: order.third, smer: Smer.doleva, view: play)
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
    
    func animate(NameTextField txtfield:order, NextButton nxtButt:order, BackButton backButt:order, smer:Smer, view:UIViewController){
        
        //order by order. Heh.
        let field = (((Double(txtfield.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        let nxt = (((Double(nxtButt.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        let back = (((Double(backButt.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        
        var x:CGFloat = 0
        
        if smer == Smer.doleva{
            x = -(self.buttonWidth)
        }else if smer == Smer.doprava{
            x = UIScreen.mainScreen().bounds.width
        }
        var poradi = 0
        UIView.animateWithDuration(0.2, delay: field, options: nil, animations: {
            self.nameTextField.frame.origin.x = x
            }, completion: { (bl:Bool) in
                poradi = poradi + 1
                self.changeView(poradi, viewContr: view, direction: smer)
        })
        
        UIView.animateWithDuration(0.2, delay: nxt, options: nil, animations: {
            self.nextButton.frame.origin.x = x
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
        titleLabel.text = "N o v ý   N i c k"
        
        UIView.animateWithDuration(0.6, animations: {
            titleLabel.frame.origin.y = 0
            titleLabel.alpha = 1
        })
        
        UIView.animateWithDuration(0.2, animations: {
            self.nameTextField.frame = self.textFieldOrigin
        })
        
        UIView.animateWithDuration(0.2, delay: 0.1, options: nil, animations: {
            self.nextButton.frame = self.nextOrigin
        }, completion: {(bl:Bool) in})
        
        UIView.animateWithDuration(0.2, delay: 0.3, options: nil, animations: {
            self.backButton.frame = self.backOrigin
        }, completion: {(bl:Bool) in})
    }
    
    func windowsObjects() -> [UIView]{
        return [self.nameTextField, self.nextButton, self.backButton]
    }
    
    func getView() -> UIView{
        return self.view
    }
    
    override init() {
        super.init(nibName: "NewNick", bundle: NSBundle.mainBundle())
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
