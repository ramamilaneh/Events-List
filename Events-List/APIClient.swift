//
//  APIClient.swift
//  Events-List
//
//  Created by Rama Milaneh on 1/26/17.
//  Copyright © 2017 Rama Milaneh. All rights reserved.
//

import Foundation
import UIKit

class APIClient {
    
    
    class func getUpcomingEvents(withIn time: Time = .week, zipCode: String = "10012",text: String = "", topic: String = "", with completion: @escaping ([[String:Any]],_ success: Bool) -> ()) {
        
        let parameter = APIClient.configureURLString(with: zipCode, text: text, topic: topic, time: time)
        
        let urlSession = URLSession(configuration: .default)
        let url = URL(string: "\(Constant.basicURLString)?\(parameter)")
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        var request = URLRequest(url: unwrappedURL)
        request.httpMethod = "GET"
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error: \(error)")
                return
            }
            let httpResponse = response as! HTTPURLResponse
            switch httpResponse.statusCode {
            case 200:
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        // To handle when there is misspelling in the text or the topic
                        if json["results"] != nil {
                            let results = json["results"] as! [[String : Any]]
                            completion(results,true)
                        }else{
                            completion([], false)
                        }
                        
                    } else {
                        completion([],true)
                    }
                }catch let error {
                    print(error)
                }
            case 400:
                // To handle invaild zip code
                completion([],false)
            default:
                print("error:\(error)")
            }
        }
        task.resume()
    }
    
    // Function to handle the different choices of searching
   static func configureURLString(with zipCode: String, text: String, topic: String, time: Time) -> String {
        
        var parameter = ""
        switch (zipCode,text,topic) {
        case ("10012","",""):
             parameter = ["key=\(Constant.key)","time=\(time.rawValue)","zip=10012"].joined(separator: "&")
        case ("10012",text,""):
            parameter = ["key=\(Constant.key)","time=\(time.rawValue)","text=\(text)"].joined(separator: "&")
        case ("10012","",topic):
            parameter = ["key=\(Constant.key)","time=\(time.rawValue)","topic=\(topic)"].joined(separator: "&")
        case (zipCode,"",""),(zipCode,text,""):
            parameter = ["key=\(Constant.key)","zip=\(zipCode)","text=\(text)","time=\(time.rawValue)"].joined(separator: "&")
        case (zipCode,"",topic):
            parameter = ["key=\(Constant.key)","zip=\(zipCode)","topic=\(topic)","time=\(time.rawValue)"].joined(separator: "&")
        case ("10012",text,topic):
            parameter = ["key=\(Constant.key)","topic=\(topic)","text=\(text)","time=\(time.rawValue)"].joined(separator: "&")
        case (zipCode,text,topic):
            parameter = ["key=\(Constant.key)","zip=\(zipCode)","topic=\(topic)","text=\(text)","time=\(time.rawValue)"].joined(separator: "&")
        default:
            break
        }

        return parameter
    }
    
}


enum Time: String {
    
    case day = ",1d", week = ",1w", month = ",1m"
}


struct Constant {
    
    static let basicURLString = "https://api.meetup.com/2/open_events"
    static let key = "6752511f3291b2b182ee4d2ef312"
    
}

