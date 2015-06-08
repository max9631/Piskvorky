//
//  ChooseLoby.swift
//  Piškvorky
//
//  Created by Adam Salih on 06/06/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import UIKit

class ChooseLoby: UIViewController, WindowManager {
    @IBOutlet weak var tableView: TableView!
    @IBOutlet weak var backButton: UIButton!

    //button dimension
    let buttonWidth = 305 as CGFloat!
    let buttonHeight = 55 as CGFloat!
    
    //place in view for buttons
    var tableViewOrigin:CGRect!
    var backOrigin:CGRect!
    var stredX:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.mainScreen().bounds
        self.view.backgroundColor = UIColor.clearColor()
        
        self.stredX = (UIScreen.mainScreen().bounds.width / 2) - (buttonWidth / 2)
        let stredT = (UIScreen.mainScreen().bounds.width / 2) - (320 / 2)
        let screenH = UIScreen.mainScreen().bounds.height
        self.tableViewOrigin = CGRect(x: stredT, y: (screenH/4), width: 320, height: (screenH/8) * 4)
        self.backOrigin =       CGRect(x: self.stredX, y: (UIScreen.mainScreen().bounds.height) - (1*(self.buttonHeight + 20)), width: self.buttonWidth, height: self.buttonHeight)
        
        func buttonSetUp(#button:UIButton, origin: CGRect){
            button.backgroundColor = lighBlue
            button.tintColor = UIColor.blackColor()
            button.layer.cornerRadius = self.buttonHeight / 2
            button.frame = origin
        }
        
        buttonSetUp(button: self.backButton, self.backOrigin)
        
        self.tableView.frame = self.tableViewOrigin
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    //MARK: - Button Methods
    
    @IBAction func goBack(sender: AnyObject) {
        let play = PlayOption()
        self.animate(TableView: order.second, BackButton: order.second, smer: Smer.doprava, view: play)
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
    
    func animate(TableView tblvw:order, BackButton backButt:order, smer:Smer, view:UIViewController){
        
        //order by order. Heh.
        let table = (((Double(tblvw.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        let back = (((Double(backButt.hashValue) - 1) * 0.2) + 0.1) as NSTimeInterval
        
        var x:CGFloat = 0
        
        if smer == Smer.doleva{
            x = -(self.buttonWidth)
        }else if smer == Smer.doprava{
            x = UIScreen.mainScreen().bounds.width
        }
        
        var poradi = 0
        
        UIView.animateWithDuration(0.2, delay: table, options: nil, animations: {
            self.tableView.frame.origin.x = x
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
        titleLabel.text = "V ý b ě r   l o b y"
        
        UIView.animateWithDuration(0.6, animations: {
            titleLabel.frame.origin.y = 0
            titleLabel.alpha = 1
        })
        
        UIView.animateWithDuration(0.2, animations: {
            self.tableView.frame = self.tableViewOrigin
        })
        
        UIView.animateWithDuration(0.2, delay: 0.1, options: nil, animations: {
            self.backButton.frame = self.backOrigin
        }, completion: {(bl:Bool) in})
        
    }
    
    func windowsObjects() -> [UIView]{
        return [self.tableView, self.backButton]
    }
    
    func getView() -> UIView{
        return self.view
    }
    
    override init() {
        super.init(nibName: "ChooseLoby", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
