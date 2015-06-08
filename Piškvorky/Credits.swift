//
//  Credits.swift
//  Piškvorky
//
//  Created by Adam Salih on 06/06/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import UIKit

class Credits: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
    }

    override init() {
        super.init(nibName: "Credits", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
