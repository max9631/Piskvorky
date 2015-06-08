//
//  Mapa.swift
//  Piškvorky
//
//  Created by Adam Salih on 10/03/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import UIKit

class Mapa: UIView{
    //MARK: - vars
    
    var volnaPolicka = [[Policko]]() // [X][Y]
    let pocetPolicekX:Int!
    let pocetPolicekY:Int!
    let velikostPolicka = 50
    let pocetNavic = 2

    //MARK: - methods
    init(hraNaPocetPolicek pocet:Int){
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        
        let database = PlayedFieldDatabase(hraNaPocetPolicek: 5)
        
        self.pocetPolicekY = (Int(UIScreen.mainScreen().bounds.height) / self.velikostPolicka) + (2 * pocetNavic) as Int
        self.pocetPolicekX = (Int(UIScreen.mainScreen().bounds.width) / self.velikostPolicka) + (2 * pocetNavic) as Int
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "gestureRecognized:")
        
        self.addGestureRecognizer(panGesture)
        self.restart(database: database)
    }
    
    func restart(database db:PlayedFieldDatabase){
        self.volnaPolicka = []
        for x in 0..<self.pocetPolicekX{
            let polePolicek = [Policko]()
            self.volnaPolicka.append(polePolicek)
            for y in 0..<self.pocetPolicekY{
                let pole = Policko(
                    x: x - self.pocetNavic,
                    y: y - self.pocetNavic,
                    database: db,
                    cross: nil
                )
                self.volnaPolicka[x].append(pole)
                pole.frame.origin.x = CGFloat((x * self.velikostPolicka) - (self.pocetNavic * self.velikostPolicka))
                pole.frame.origin.y = CGFloat((y * self.velikostPolicka) - (self.pocetNavic * self.velikostPolicka))
                pole.frame.size.width = CGFloat(self.velikostPolicka)
                pole.frame.size.height = CGFloat(self.velikostPolicka)
                self.addSubview(pole)
            }
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var firstPosition:CGPoint!
    func gestureRecognized(pan:UIPanGestureRecognizer){
        switch pan.state{
        case .Began:
            self.firstPosition = pan.locationInView(self)
        case .Changed:
            let panPosition = pan.locationInView(self)
            let rozdilX = self.firstPosition.x - panPosition.x
            let rozdilY = self.firstPosition.y - panPosition.y
            for policka in self.volnaPolicka{
                for policko in policka{
                    policko.frame.origin.x -= rozdilX
                    policko.frame.origin.y -= rozdilY
                }
            }
            self.firstPosition = panPosition
        default:
            doNothing()
        }
        self.swap()
    }
    
    var pivotX = 0 as Int   //ukazuje vzdy na pravy horni roh
    var pivotY = 0 as Int   //cim vetsi, tim vic vpravo
    func swap(){
        let mensiX = mensiPivot(x: true)
        let mensiY = mensiPivot(x: false)
        if self.volnaPolicka[pivotX][0].frame.origin.x < CGFloat(-(self.pocetNavic * self.velikostPolicka)){ // upravuje posun vpravo
            let noveX = self.volnaPolicka[mensiX][0].frame.origin.x + CGFloat(self.velikostPolicka)
            for var index = 0; index < self.pocetPolicekY; index++ {
                self.volnaPolicka[pivotX][index].frame.origin.x = noveX
                self.volnaPolicka[pivotX][index].osaX = self.volnaPolicka[mensiX][index].osaX + 1
                self.volnaPolicka[pivotX][index].refresh()
            }
            if self.pivotX >= self.pocetPolicekX - 1{
                self.pivotX = 0
            }else{
                self.pivotX++
            }
        }
        if self.volnaPolicka[0][pivotY].frame.origin.y < CGFloat(-(self.pocetNavic * self.velikostPolicka)){ // upravuje posun dolu
            let noveY = self.volnaPolicka[0][mensiY].frame.origin.y + CGFloat(self.velikostPolicka)
            for var index = 0; index < self.pocetPolicekX; index++ {
                self.volnaPolicka[index][pivotY].frame.origin.y = noveY
                self.volnaPolicka[index][pivotY].osaY = self.volnaPolicka[index][mensiY].osaY + 1
                self.volnaPolicka[index][pivotY].refresh()
            }
            if self.pivotY == self.pocetPolicekY - 1{
                self.pivotY = 0
            }else{
                self.pivotY++
            }
        }
        if self.volnaPolicka[mensiX][self.pocetPolicekX - 1].frame.origin.x > (UIScreen.mainScreen().bounds.width + CGFloat(self.pocetNavic * self.velikostPolicka)){ //upravuje posun doleva
            let noveX = self.volnaPolicka[pivotX][self.pocetPolicekX - 1].frame.origin.x - CGFloat(self.velikostPolicka)
            for var index = 0; index < self.pocetPolicekY; index++ {
                self.volnaPolicka[mensiX][index].frame.origin.x = noveX
                self.volnaPolicka[mensiX][index].osaX = self.volnaPolicka[pivotX][index].osaX - 1
                self.volnaPolicka[mensiX][index].refresh()
            }
            if self.pivotX == 0{
                self.pivotX = self.pocetPolicekX - 1
            }else{
                self.pivotX--
            }
        }
        if self.volnaPolicka[self.pocetPolicekX - 1][mensiY].frame.origin.y > (UIScreen.mainScreen().bounds.height + CGFloat(self.pocetNavic * self.velikostPolicka)){ // upravuje posun nahoru
            let noveY = self.volnaPolicka[0][pivotY].frame.origin.y - CGFloat(self.velikostPolicka)
            for var index = 0; index < self.pocetPolicekX; index++ {
                self.volnaPolicka[index][mensiY].frame.origin.y = noveY
                self.volnaPolicka[index][mensiY].osaY = self.volnaPolicka[index][pivotY].osaY - 1
                self.volnaPolicka[index][mensiY].refresh()
            }
            if self.pivotY == 0{
                self.pivotY = self.pocetPolicekY - 1
            }else{
                self.pivotY--
            }
        }
    }
    
    func mensiPivot(#x:Bool) -> Int{
        var tmpPivot:Int
        if x{
            if self.pivotX == 0{
                tmpPivot = self.pocetPolicekX - 1
            }else{
                tmpPivot = self.pivotX - 1
            }
        }else{
            if self.pivotY == 0{
                tmpPivot = self.pocetPolicekY - 1
            }else{
                tmpPivot = self.pivotY - 1
            }
        }
        return tmpPivot
    }
    
    func doNothing(){}
}








































