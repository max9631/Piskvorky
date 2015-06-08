//
//  OnlineMultiplayer.swift
//  Piškvorky
//
//  Created by Adam Salih on 17/05/15.
//  Copyright (c) 2015 Adam Salih. All rights reserved.
//

import Foundation

class OnlineMultiplayer:NSObject {
    var nickname:String!
    
    override init() {
        let documentDirectoryWithoutPlist = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let nickar = NSArray(contentsOfFile: "\(documentDirectoryWithoutPlist[0])/nick.plist")!
        self.nickname = nickar[0] as String
    }
    
    func lostOfFreeGames()->[[String]]{
        let request = NSMutableURLRequest(URL: NSURL(string: "http://student.sspbrno.cz/~zhor.vojtech/pix.php?request=freegame")!)
        request.HTTPMethod = "POST"
        let error = NSErrorPointer()
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: error)
        var pole = [] as [[String]]
        if let datData = data as NSData!{
            if let json = JSON(data: datData, options: NSJSONReadingOptions.AllowFragments, error: nil).arrayValue! as [JSON]!{
                for var i = 0; i < json.count; i = i + 1{
                    //            println("inloop")
                    if i%2 == 0{
                        pole.append([json[i].stringValue!, json[i+1].stringValue!])
                    }
                }
            }
        }
        return pole
    }
    
    func createLoby(#name:String) -> String{
        let request = NSMutableURLRequest(URL: NSURL(string: "http://student.sspbrno.cz/~zhor.vojtech/pix.php?request=creategame&jmeno=\(name)")!)
        request.HTTPMethod = "GET"
        let error = NSErrorPointer()
        let datData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: error)
        var id = ""
        if let data = datData as NSData!{
            id = NSString(data: data, encoding: NSUTF8StringEncoding)!
        }
        return id
    }
}