//
//  Event.swift
//  Events-List
//
//  Created by Rama Milaneh on 1/27/17.
//  Copyright © 2017 Rama Milaneh. All rights reserved.
//

import Foundation

struct Event: Equatable {
    
    let name: String
    let date: String
    let address: String
    let groupName: String
    let yesRSVP: Int
    let location: String
    var isFavorite = false
    let id: String
    
    init(eventDic: [String:Any]) {
        
        let id = eventDic["id"] as? String ?? ""
        let name = eventDic["name"] as? String ?? ""
        let venue = eventDic["venue"] as? [String:Any] ?? [:]
        let group = eventDic["group"] as? [String:Any] ?? [:]
        let locationName = venue["name"] as? String ?? "No Available Location"
        let groupName = group["name"] as? String ?? ""
        let address1 = venue["address_1"] as? String ?? "Address is shown only to members"
        let city = venue["city"] as? String ?? ""
        let state = venue["state"] as? String ?? ""
        let zip = venue["zip"] as? String ?? ""
        let yesRSVP = eventDic["yes_rsvp_count"] as? Int ?? 0
        let dateInt = eventDic["time"] as? Int ?? 0
        let date = dateInt.dateFromMilliseconds()
        let address = "\(address1),\(city),\(state)\(zip)"
        self.id = id
        self.name = name
        self.groupName = groupName
        if address1 == "Address is shown only to members" {
           self.address = address1
        }else{
            self.address = address
        }
        self.yesRSVP = yesRSVP
        self.date = date
        self.location = locationName
    }
    
    static func ==(lhs:Event, rhs:Event) -> Bool { // Implement Equatable
        return lhs.id == rhs.id
    }
}

extension Int {
    
    func dateFromMilliseconds() -> String {
    
        let date = Date(timeIntervalSince1970: TimeInterval(self)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE,MMM d,yyyy, h:mm a"
        return dateFormatter.string(from: date)
    }
}
