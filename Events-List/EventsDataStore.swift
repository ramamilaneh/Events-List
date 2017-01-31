//
//  EventsDataStore.swift
//  Events-List
//
//  Created by Rama Milaneh on 1/27/17.
//  Copyright © 2017 Rama Milaneh. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EventsDataStore {
    
    static let sharedInstance = EventsDataStore()
    private init() {}
    var events: [Event] = []
    var favoriteEvents: [Event] = []
    
    func createEvents(completionHandler: @escaping (Bool) -> ()) {
        APIClient.getUpcomingEvents { (eventsArray, success) in
            if eventsArray.count != 0 && success == true {
                self.events = []
                for i in 0...10 {
                    self.events.append(Event(eventDic: eventsArray[i]))
                }
                completionHandler(true)
            }else{
                completionHandler(false)
            }
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "FavoriteModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}
