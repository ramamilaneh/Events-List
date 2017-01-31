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
    var favoriteEventsID = [FavoriteEvents]()

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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func addFavoriteEventToCoreData(with id:String) {
        let managedContext = self.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteEvents", in: managedContext)
        if let unwrappedEntity = entity {
            let favoriteEvent = NSManagedObject(entity: unwrappedEntity, insertInto: managedContext) as! FavoriteEvents
            favoriteEvent.id = id
            do {
                try managedContext.save()
            }catch {}
        }
        saveContext()
    }
    
    func deleteFavoriteEventFromCoreData(with id: String) {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteEvents> = FavoriteEvents.fetchRequest()
        if let result = try? managedContext.fetch(fetchRequest) {
            for object in result {
                if object.id == id {
                    managedContext.delete(object)
                }
            }
            do {
                try managedContext.save()
            }catch let error {
                print(error.localizedDescription)
            }
        }
        saveContext()
    }

    func emptyCoreData() {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteEvents> = FavoriteEvents.fetchRequest()
        if let result = try? managedContext.fetch(fetchRequest) {
            for object in result {
                
                managedContext.delete(object)
                
            }
            do {
                try managedContext.save()
            }catch let error {
                print(error.localizedDescription)
            }
        }
    
    }

    func fetchData(){
        
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteEvents> = FavoriteEvents.fetchRequest()
        do{
            self.favoriteEventsID = try managedContext.fetch(fetchRequest)
        }catch let error {
            print(error.localizedDescription)
        }
    }

    
}
