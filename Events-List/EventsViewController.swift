//
//  ViewController.swift
//  Events-List
//
//  Created by Rama Milaneh on 1/26/17.
//  Copyright © 2017 Rama Milaneh. All rights reserved.
//

import UIKit
import CoreData

class EventsViewController:  UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let store = EventsDataStore.sharedInstance
    private let cellId = "eventCell"
    var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: self.view.frame.width, height: 0.45*self.view.frame.height)
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        self.collectionView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: cellId)
        //store.emptyCoreData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.fetchData()
        self.store.createEvents { (success) in
            if success {
                self.ckeckFavoriteEvents()
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        store.fetchData()
//        self.store.createEvents { (success) in
//            if success {
//                self.ckeckFavoriteEvents()
//                OperationQueue.main.addOperation {
//                    self.collectionView?.reloadData()
//                }
//            }
//        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCell
        if store.events.count > 0 {
            cell.event = store.events[indexPath.item]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell =  collectionView.cellForItem(at: indexPath) as! EventCell
        let id = self.store.events[indexPath.item].id
        if store.events[indexPath.item].isFavorite == true {
            store.events[indexPath.item].isFavorite = false
            //store.favoriteEvents.remove(at: in)
            DispatchQueue.main.async {
                cell.favoriteMark.image = UIImage(named: "unstarred")?.tint(color: UIColor.red)
            }
            self.store.deleteFavoriteEventFromCoreData(with: id)
        }else{
            store.events[indexPath.item].isFavorite = true
            DispatchQueue.main.async {
                cell.favoriteMark.image = UIImage(named: "starred")?.tint(color: UIColor.red)
            }
            self.store.addFavoriteEventToCoreData(with: id)
        }
        cell.isSelected = !(cell.isSelected)
        
    }
    
       
    func ckeckFavoriteEvents() {
        
        self.store.favoriteEvents.removeAll()
        for (index,event) in self.store.events.enumerated(){
            for eventID in self.store.favoriteEventsID {
                if event.id == eventID.id {
                    self.store.events[index].isFavorite = true
                }
                if (event.id == eventID.id) && !self.store.favoriteEvents.contains(self.store.events[index]) {
                    self.store.favoriteEvents.append( self.store.events[index])
                }
            }
        }
    }
    
}

