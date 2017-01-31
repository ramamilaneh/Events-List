//
//  ViewController.swift
//  Events-List
//
//  Created by Rama Milaneh on 1/26/17.
//  Copyright © 2017 Rama Milaneh. All rights reserved.
//

import UIKit
import CoreData

class EventsViewController:  UICollectionViewController, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate  {
    
    let store = EventsDataStore.sharedInstance
    private let cellId = "eventCell"
    var favoriteEventsID = [FavoriteEvents]()
    override func viewDidLoad() {
        super.viewDidLoad()
      //  emptyCoreData()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(EventCell.self, forCellWithReuseIdentifier: cellId)

//        collectionView?.alwaysBounceVertical = true
          collectionView?.delegate = self
        collectionView?.dataSource = self
        self.tabBarController?.delegate = self
        if tabBarController?.selectedIndex == 0{
            self.title = "Events"
            
        }else{
            self.title = "Favorite"
        }
     //  collectionView?.reloadData()
        fetchData()
      print(self.favoriteEventsID.count)
        for event in self.favoriteEventsID {
            print(event.id)
        }
        self.store.favoriteEvents.removeAll()
        self.store.createEvents { (success) in
            if success {
                
                DispatchQueue.main.async {
                    self.ckeckFavoriteEvents()
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
   
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if tabBarController.selectedIndex == 1 {
//            fetchData()
//            self.store.favoriteEvents.removeAll()
//            for (index,event) in self.store.events.enumerated(){
//                for eventID in self.favoriteEventsID {
//                    if event.id == eventID.id {
//                        self.store.favoriteEvents.append(event)
//                    }
//                }
//            }
//        }
//        }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.store.favoriteEvents.removeAll()
//        self.ckeckFavoriteEvents()
        collectionView?.reloadData()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tabBarController?.selectedIndex == 0 {

      //      return 10
      return self.store.events.count
        }else{
        //    return 3
            return self.store.favoriteEvents.count
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCell
        
        if tabBarController?.selectedIndex == 0 {
            cell.event = store.events[indexPath.item]
        }else{
            cell.event = store.favoriteEvents[indexPath.item]
        }
       // cell.backgroundColor = UIColor.green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 0.45*view.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell =  collectionView.cellForItem(at: indexPath) as! EventCell
        let id = self.store.events[indexPath.item].id
        if store.events[indexPath.item].isFavorite == true {
            store.events[indexPath.item].isFavorite = false
            DispatchQueue.main.async {
                cell.favoriteMark.image = UIImage(named: "unstarred")?.tint(color: UIColor.red)
            }
            //self.deleteFavoriteEvent(with: id)
            self.deleteFavoriteEventFromCoreData(with: id)
            
            
        }else{
            store.events[indexPath.item].isFavorite = true
            DispatchQueue.main.async {
                cell.favoriteMark.image = UIImage(named: "starred")?.tint(color: UIColor.red)
            }
            //self.store.favoriteEvents.append(self.store.events[indexPath.item])
            self.addFavoriteEvent(with: id)
        }
        fetchData()
        cell.isSelected = !(cell.isSelected)
        collectionView.reloadData()
       
        //print(self.store.favoriteEvents.count)
        //print(self.store.events[indexPath.item].isFavorite)
    }
    
    func addFavoriteEvent(with id:String) {
        let managedContext = store.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteEvents", in: managedContext)
        if let unwrappedEntity = entity {
            let favoriteEvent = NSManagedObject(entity: unwrappedEntity, insertInto: managedContext) as! FavoriteEvents
            favoriteEvent.id = id
            do {
                try managedContext.save()
            }catch {}
        }
    }
    
    
    func deleteFavoriteEventFromCoreData(with id: String) {
        let managedContext = store.persistentContainer.viewContext
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
    }
    
    func emptyCoreData() {
        let managedContext = store.persistentContainer.viewContext
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
    
    func deleteFavoriteEvent(with id: String) {
        for (index,event) in self.store.favoriteEvents.enumerated() {
            if event.id == id {
                self.store.favoriteEvents.remove(at: index)
            }
            
        }
    }
    
    func fetchData(){
        let managedContext = store.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteEvents> = FavoriteEvents.fetchRequest()
        do{
            self.favoriteEventsID = try managedContext.fetch(fetchRequest)
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func ckeckFavoriteEvents() {
        
        for (index,event) in self.store.events.enumerated(){
            for eventID in self.favoriteEventsID {
                if event.id == eventID.id {
                    self.store.events[index].isFavorite = true
                    self.store.favoriteEvents.append( self.store.events[index])
                }
            }
        }

    }
    
}

