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
    var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Events"
        setupViews()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func setupViews() {
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.frame = CGRect(x: self.view.center.x - 25 , y: self.view.center.y - 70, width: 50, height: 50)
        activityIndicatorView.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
        activityIndicatorView.layer.cornerRadius = 10
        activityIndicatorView.clipsToBounds = true
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: self.view.frame.width, height: 0.45*self.view.frame.height)
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        self.collectionView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        collectionView.addSubview(activityIndicatorView)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.activityIndicatorView.startAnimating()
        self.store.fetchData()
        self.store.createEvents { (success) in
            if success {
                self.ckeckFavoriteEvents()
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.collectionView?.reloadData()
                }
            }
        }
        
        
    }
    
    // MARK: UICollectionViewDataSource
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
    
    // Check if there is any matching between the favorite events ID from Core Data and the Events
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

