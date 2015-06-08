//
//  NewLoby.swift
//  Piškvorky
//
//  Created by Adam Salih on 06/06/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import UIKit

class NewLoby: UIViewController, WindowManager {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var createLobyButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //button dimension
    let buttonWidth = 305 as CGFloat!
    let buttonHeight = 55 as CGFloat!
    
    //place in view for buttons
    var nameFieldOrigin:CGRect!
    var createOrigin:CGRect!
    var backOrigin:CGRect!
    var stredX:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.mainScreen().bounds
        self.view.backgroundColor = UIColor.clearColor()
        
        self.stredX = (UIScreen.mainScreen().bounds.width / 2) - (buttonWidth / 2)
        let screenH = UIScreen.mainScreen().bounds.height
        self.nameFieldOrigin =  CGRect(x: self.stredX, y: (screenH / 2) - (self.buttonHeight + 10), width: self.buttonWidth, height: self.buttonHeight)
        self.createOrigin    =  CGRect(x: self.stredX, y: (screenH / 2) + 10, width: self.buttonWidth, height: self.buttonHeight)
        self.backOrigin      =  CGRect(x: self.stredX, y: (UIScreen.mainScreen().bounds.height) - (1*(self.buttonHeight + 20)), width: self.buttonWidth, height: self.buttonHeight)
        
        func buttonSetUp(#button:UIButton, origin: CGRect){
            button.backgroundColor = lighBlue
            button.tintColor = UIColor.blackColor()
            button.layer.cornerRadius = self.buttonHeight / 2
            button.frame = origin
        }
        
        buttonSetUp(button: self.createLobyButton, createOrigin)
        buttonSetUp(button: self.backButton, self.backOrigin)
        
        self.nameTextField.backgroundColor = lighBlue
        self.nameTextField.frame = self.nameFieldOrigin
        self.txtdlgt = TextFieldDelegate(viewController: self, textField: self.nameTextField)
        self.nameTextField.delegate = self.txtdlgt
    }
    var txtdlgt:TextFieldDelegate!
    
    //MARK: - Button Methods
    
    @IBAction func createLoby(sender: AnyObject) {
        if self.nameTextField.text == ""{
            let alert = UIAlertView()
            alert.title = "Prázdné pole"
            alert.message = "Bez názvu to nepůjde, kámo"
            alert.addButtonWithTitle("OK")
            alert.show()
        }else{
            let connection = OnlineMultiplayer()
            connection.createLoby(name: self.nameTextField.text)
            let play = PlayOption()
            self.animate(NameField: order.first, CreateLobyButton: order.second, BackButton: order.third, smer: Smer.doleva, view: play)
        }
    }
    
    @IBAction func goBack(sender: AnyObject) {
        let main = PlayOption()
        self.animate(NameField: order.third, CreateLobyButton: order.second, BackButton: order.first, smer: Smer.doprava, view: main)
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
    
    func animate(NameField fld:order, CreateLobyButton crt:order, BackButton backButt:order, smer:Smer, view:UIViewController){
        
        //order by order. Heh.
        let field = (((Double(fld.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        let creat = (((Double(crt.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
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
        
        UIView.animateWithDuration(0.2, delay: creat, options: nil, animations: {
            self.createLobyButton.frame.origin.x = x
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
        titleLabel.text = "N o v é   l o b y"
        
        UIView.animateWithDuration(0.6, animations: {
            titleLabel.frame.origin.y = 0
            titleLabel.alpha = 1
        })
        
        UIView.animateWithDuration(0.2, animations: {
            self.nameTextField.frame = self.nameFieldOrigin
        })
        
        UIView.animateWithDuration(0.2, delay: 0.1, options: nil, animations: {
            self.createLobyButton.frame = self.createOrigin
            }, completion: {(bl:Bool) in})
        
        UIView.animateWithDuration(0.2, delay: 0.3, options: nil, animations: {
            self.backButton.frame = self.backOrigin
            }, completion: {(bl:Bool) in})
        
    }
    
    func windowsObjects() -> [UIView]{
        return [self.nameTextField, self.createLobyButton, self.backButton]
    }
    
    func getView() -> UIView{
        return self.view
    }
    
    override init() {
        super.init(nibName: "NewLoby", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
