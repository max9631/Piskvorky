//
//  Policko.swift
//  Piškvorky
//
//  Created by Adam Salih on 10/03/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import UIKit

class Policko: UIView {
    
    var database:PlayedFieldDatabase!
    var cross:Bool?
    var osaX:Int!
    var osaY:Int!
    
    var img:UIView!
    
//    var label:UILabel!

    init(x:Int, y:Int, database db:PlayedFieldDatabase, cross crs:Bool?) {
        super.init()
        self.osaX = x
        self.osaY = y
        self.cross = crs
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 0.5
        self.database = db
        let tapGesture = UITapGestureRecognizer(target: self, action: "gestureRecognized:")
        self.addGestureRecognizer(tapGesture)
        
//        let lbl = UILabel()
//        lbl.frame.size = CGSize(width: 50, height: 10)
//        lbl.frame.origin = self.frame.origin
//        lbl.text = "\(x), \(y)"
//        lbl.adjustsFontSizeToFitWidth = false
//        lbl.font = lbl.font.fontWithSize(10)
//        self.label = lbl
//        self.addSubview(lbl)
    }
    
    func set(cross cros:Bool) -> Bool{
        if self.cross == nil{
            self.cross = cros
            if cros{
                let UICross = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
                self.database.addPolicko(self.osaX, y: self.osaY, cross: true)
                let upperLine = UIView() //–
                upperLine.backgroundColor = UIColor.blackColor()
                upperLine.frame.size.width = self.frame.width
                upperLine.frame.size.height = 1
                UICross.addSubview(upperLine)
                upperLine.frame.origin.y = self.frame.width / 2
                upperLine.transform = CGAffineTransformMakeRotation(CGFloat(45) * CGFloat(M_PI/180))
                
                let lowerLine = UIView()// |
                lowerLine.backgroundColor = UIColor.blackColor()
                lowerLine.frame.size.height = self.frame.width
                lowerLine.frame.size.width = 1
                UICross.addSubview(lowerLine)
                lowerLine.frame.origin.x = self.frame.width / 2
                lowerLine.transform = CGAffineTransformMakeRotation(CGFloat(45) * CGFloat(M_PI/180))
                self.addSubview(UICross)
                self.img = UICross
            }else{
                self.database.addPolicko(self.osaX, y: self.osaY, cross: false)
                let side = (self.frame.width / 3)*2
                let circle = UIView()
                circle.frame.size.width = side
                circle.frame.size.height = side
                circle.layer.cornerRadius = side / 2
                circle.layer.masksToBounds = true
                circle.layer.borderColor = UIColor.blackColor().CGColor
                circle.layer.borderWidth = 1
                self.addSubview(circle)
                circle.frame.origin.x = (self.frame.width / 3) / 2
                circle.frame.origin.y = (self.frame.width / 3) / 2
                self.img = circle
            }
            return true
        }else{
            return false
        }
    }
    
    func refresh(){
//        self.label.text = "\(self.osaX), \(self.osaY)"
        if let cros = self.database.polickoProOsu(x: self.osaX, y: self.osaY){
            if self.cross == nil{
                self.cross = cros
                if cros{
                    let UICross = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
                    let upperLine = UIView() //–
                    upperLine.backgroundColor = UIColor.blackColor()
                    upperLine.frame.size.width = self.frame.width
                    upperLine.frame.size.height = 1
                    UICross.addSubview(upperLine)
                    upperLine.frame.origin.y = self.frame.width / 2
                    upperLine.transform = CGAffineTransformMakeRotation(CGFloat(45) * CGFloat(M_PI/180))
                    
                    let lowerLine = UIView()// |
                    lowerLine.backgroundColor = UIColor.blackColor()
                    lowerLine.frame.size.height = self.frame.width
                    lowerLine.frame.size.width = 1
                    UICross.addSubview(lowerLine)
                    lowerLine.frame.origin.x = self.frame.width / 2
                    lowerLine.transform = CGAffineTransformMakeRotation(CGFloat(45) * CGFloat(M_PI/180))
                    self.addSubview(UICross)
                    self.img = UICross
                }else{
                    let side = (self.frame.width / 3)*2
                    let circle = UIView()
                    circle.frame.size.width = side
                    circle.frame.size.height = side
                    circle.layer.cornerRadius = side / 2
                    circle.layer.masksToBounds = true
                    circle.layer.borderColor = UIColor.blackColor().CGColor
                    circle.layer.borderWidth = 1
                    self.addSubview(circle)
                    circle.frame.origin.x = (self.frame.width / 3) / 2
                    circle.frame.origin.y = (self.frame.width / 3) / 2
                    self.img = circle
                }
            }
        }else{
            if self.img != nil{
                self.img.removeFromSuperview()
                self.img = nil
                self.cross = nil
            }
        }
//        self.set(cross:self.database.polickoProOsu(x: self.osaX, y: self.osaY))
    }
    
    func gestureRecognized(tap:UIGestureRecognizer){
        self.set(cross: self.database.tmpCross)
        self.database.tmpCross = !self.database.tmpCross
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
