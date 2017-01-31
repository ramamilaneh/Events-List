//
//  JohannViewController.swift
//  Events-List
//
//  Created by Rama Milaneh on 1/31/17.
//  Copyright © 2017 Rama Milaneh. All rights reserved.
//

import UIKit

class JohannViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    let store = EventsDataStore.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        //layout.minimumInteritemSpacing
        layout.itemSize = CGSize(width: 100, height: 100)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.0).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "basicCell")
        

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        store.createEvents { (success) in
            if success {
                print("I should have some stuff")
                OperationQueue.main.addOperation {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basicCell", for: indexPath)
        
        cell.backgroundColor = UIColor.getRandomColor()
        
        return cell
    }

    
}


extension UIColor {
    class func getRandomColor () -> UIColor {
        let red = CGFloat(drand48())
        let blue = CGFloat(drand48())
        let green = CGFloat(drand48())
        
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)


    }
}
