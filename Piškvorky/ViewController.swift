//
//  ViewController.swift
//  Piškvorky
//
//  Created by Adam Salih on 10/03/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import UIKit

let lighBlue = UIColor(red: 0.85, green: 0.97, blue: 0.98, alpha: 1)
let blue = UIColor(red: 0.66, green: 0.93, blue: 0.93, alpha: 0.9)
let darkBlue = UIColor(red: 0.29, green: 0.8, blue: 0.79, alpha: 0.9)

class ViewController: UIViewController {
    
    var mapa: Mapa!
    var menu:MenuWindow!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let map = Mapa(hraNaPocetPolicek: 5)
        self.mapa = map
        self.mapa.frame.origin.y = 20
        self.view.addSubview(self.mapa)
        self.menu = MenuWindow()
        self.view.addSubview(self.menu.view)
        let notCenter = NSNotificationCenter.defaultCenter()
        notCenter.addObserver(self, selector: "startGame", name: "NewGame", object: nil)
        notCenter.addObserver(self, selector: "endGame:", name: "EndGame", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func startGame(){
        self.mapa.restart(database: PlayedFieldDatabase(hraNaPocetPolicek: 5))
        UIView.animateWithDuration(0.75, animations: {
            self.menu.view.frame.origin.y = -(self.menu.view.frame.height)
        })
    }
    
    func endGame(notification:NSNotification){
        let any: AnyObject = self.menu.currentWindow
        let vc = any as UIViewController
        vc.view.removeFromSuperview()
        let notcen = NSNotificationCenter.defaultCenter()
        let win = WinScreenViewController(cross: notification.object as Bool)
        notcen.postNotificationName("segueToAnotherScreen", object: win, userInfo: ["smer":"doprava", "color":"white"])
        UIView.animateWithDuration(0.75, animations: {
            self.menu.view.frame.origin.y = 0
        })
    }
}

