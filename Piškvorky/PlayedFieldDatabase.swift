//
//  PlayedFieldDatabase.swift
//  Piškvorky
//
//  Created by Adam Salih on 29/03/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import Foundation

enum Smer{
    case nahoruDoleva
    case nahoru
    case nahoruDoprava
    case doprava
    case doluDoprava
    case dolu
    case doluDoleva
    case doleva
}

class PlayedFieldDatabase:NSObject{
    //MARK: - vars
    
    var osaX = [Int:[Int:Bool?]]()
    var hraNaPocetPolicek: Int!
    
    var tmpCross = true
    
    //MARK: - methods
    
    init(hraNaPocetPolicek pocet:Int) {
        super.init()
        self.hraNaPocetPolicek = pocet
    }
    
    func restart(sHrouNaPocetPolicek pocet:Int){
        self.osaX = [:]
        self.hraNaPocetPolicek = pocet
    }
    
    func polickoProOsu(#x: Int, y: Int) -> Bool?{
        if var osaY = osaX[x] as [Int:Bool?]?{
            return osaY[y]?
        }
        return nil
    }
    
    func addPolicko(x:Int, y:Int, cross:Bool){
        if var osaY = osaX[x] as [Int:Bool?]?{
            if osaY[y] == nil{
                osaY[y] = cross
                osaX[x] = osaY
            }
        }else{
            osaX[x] = [y:cross]
        }
        let smery = self.zjistiSmerProPolicko(x: x, y: y, cross: cross)
        self.count = 0
        for smer in smery{
            //TODO: pocitani v obou smerech
            let pocet = self.spocitejPolickaPo(smeru: smer, zeSouradnicX: x, Y: y, proKrizek: cross) + 1
            println("Ve smeru \(smer.hashValue) je \(pocet) policek")
            if pocet == self.hraNaPocetPolicek{
                //TODO: dodelat konec
                println("konec!")
                let notcen = NSNotificationCenter.defaultCenter()
                notcen.postNotificationName("EndGame", object: cross)
            }
        }
    }
    
    func zjistiSmerProPolicko(#x:Int, y:Int, cross:Bool) -> [Smer]{
        var smery = [] as [Smer]
        for var cykX = x - 1; cykX <= x + 1; cykX++ {
            if var osaY = osaX[cykX] as [Int:Bool?]?{
                for var cykY = y - 1; cykY <= y + 1; cykY++ {
                    if osaY[cykY]? == cross{
                        switch (cykX - x, cykY - y){
                        case(-1, -1):
                            smery.append(Smer.doluDoleva)
                        case(-1, 0):
                            smery.append(Smer.doleva)
                        case(-1, 1):
                            smery.append(Smer.nahoruDoleva)
                        case(0, -1):
                            smery.append(Smer.nahoru)
                        case(0, 1):
                            smery.append(Smer.dolu)
                        case(1, -1):
                            smery.append(Smer.nahoruDoprava)
                        case(1, 0):
                            smery.append(Smer.doprava)
                        case(1, 1):
                            smery.append(Smer.doluDoprava)
                        default:
                            doNothing()
                        }
                    }
                }
            }
        }
        return smery
    }
    
    var count = 0
    func spocitejPolickaPo(smeru smer: Smer, zeSouradnicX origX: Int, Y origY:Int, proKrizek cross:Bool) -> Int{
        var x = 0
        var y = 0
        
        switch smer{
        case .nahoruDoleva:
            x = origX - 1
            y = origY - 1
        case .nahoru:
            x = origX
            y = origY - 1
        case .nahoruDoprava:
            x = origX + 1
            y = origY - 1
        case .doprava:
            x = origX + 1
            y = origY
        case .doluDoprava:
            x = origX + 1
            y = origY + 1
        case .dolu:
            x = origX
            y = origY + 1
        case .doluDoleva:
            x = origX - 1
            y = origY + 1
        case .doleva:
            x = origX - 1
            y = origY
        default:
            doNothing()
        }
        if var osaY = osaX[x] as [Int:Bool?]?{
            if osaY[y]? == cross{
                if self.count == (self.hraNaPocetPolicek + 2){ // count je od nuly, takze by to melo byt o jedno vetsi
                    return 0
                }else{
                    self.count++
                    return 1 + self.spocitejPolickaPo(smeru: smer, zeSouradnicX: x, Y: y, proKrizek: cross)
                }
            }else{
                return 0
            }
        }
        return 0
    }
    
    func doNothing(){}
}