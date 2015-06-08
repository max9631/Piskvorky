//
//  TableViewDelegate.swift
//  Piškvorky
//
//  Created by Adam Salih on 07/06/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import UIKit

class TableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var data = [] as [[String]]!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
        self.separatorColor = UIColor.clearColor()
        let connection = OnlineMultiplayer()
        self.data = connection.lostOfFreeGames()
    }
    
    //MARK: - Delegate
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
//        
//    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 55
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 10
    }
    
//    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool{
//        return false
//    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
    
    //MARK: - Data Source
   
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = TableViewCell()
        let array = self.data[indexPath.section] as [String]
        cell.layer.cornerRadius = 10
        cell.backgroundColor = lighBlue
        cell.textLabel!.text = array[1]
        cell.textLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        let id = array[0] as String
        cell.id = id
        cell.textLabel!.textAlignment = NSTextAlignment.Center
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return self.data.count
    }
    
}
