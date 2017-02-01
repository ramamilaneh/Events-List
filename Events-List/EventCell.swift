//
//  EventCellCollectionViewCell.swift
//  Events-List
//
//  Created by Rama Milaneh on 1/27/17.
//  Copyright © 2017 Rama Milaneh. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    let eventNameLabel = UILabel()
    let eventTimeLabel = UILabel()
    let eventAddressLabel = UILabel()
    let eventgroupNameLabel = UILabel()
    let yesRSVPLabel = UILabel()
    let favoriteMark = UIImageView()
    let labelFont = UIFont(name: "HelveticaNeue-Bold", size: 18)
    let color = UIColor(white: 0.2, alpha: 1)
    
    var event: Event? {
        didSet{
            DispatchQueue.main.async {
                if (self.event?.isFavorite)! == false {
                    self.favoriteMark.image = UIImage(named: "unstarred")?.tint(color: UIColor.red)
                }else{
                    self.favoriteMark.image = UIImage(named: "starred")?.tint(color: UIColor.red)
                }
                self.updateTextLabels(with: self.event!)
            }
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        self.addSubview(eventNameLabel)
        self.addSubview(eventTimeLabel)
        self.addSubview(eventAddressLabel)
        self.addSubview(eventgroupNameLabel)
        self.addSubview(yesRSVPLabel)
        self.addSubview(favoriteMark)
        
        
        self.eventNameLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0.05*self.frame.height, leftConstant: 25, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 60)
        self.eventNameLabel.font = labelFont
        self.eventNameLabel.numberOfLines = 0
        self.eventNameLabel.lineBreakMode = .byWordWrapping
        self.eventNameLabel.sizeToFit()
        
        self.eventTimeLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0.3*self.frame.height, leftConstant: 25, bottomConstant: 0, rightConstant: 25, widthConstant: 0, heightConstant: 20)
        
        self.eventAddressLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0.45*self.frame.height, leftConstant: 25, bottomConstant: 0, rightConstant: 10, widthConstant:  0, heightConstant: 60)
        self.eventAddressLabel.numberOfLines = 0
        
        let logoLabel = UILabel()
        self.addSubview(logoLabel)
        logoLabel.text = "👤"
        logoLabel.font = UIFont.systemFont(ofSize: 14)
        logoLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0.67*self.frame.height, leftConstant: 25, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
        self.eventgroupNameLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0.65*self.frame.height, leftConstant: 55, bottomConstant: 0, rightConstant: 25, widthConstant: 0, heightConstant: 50)
        self.eventgroupNameLabel.numberOfLines = 0
        self.eventgroupNameLabel.lineBreakMode = .byWordWrapping
        self.eventgroupNameLabel.sizeToFit()
        
        self.yesRSVPLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant:  0.82*self.frame.height, leftConstant: 25, bottomConstant: 0, rightConstant: 0, widthConstant: 0.9*self.frame.width, heightConstant: 50)
        
        
        self.favoriteMark.anchor(self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 0.82*self.frame.height, leftConstant: 0, bottomConstant: 0, rightConstant: 50, widthConstant: 30, heightConstant: 30)
        self.favoriteMark.backgroundColor = UIColor.clear
        
    }
    
    // Update the label's Text with the event info
    func updateTextLabels(with event:Event) {
        
        self.eventNameLabel.text = event.name
        
        self.eventTimeLabel.attributedText = NSMutableAttributedString(string: "🕖   \(event.date)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold), NSForegroundColorAttributeName: color])
        
        let attributedText = NSMutableAttributedString(string: "📍  \(event.location)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold), NSForegroundColorAttributeName: color])
        attributedText.append(NSAttributedString(string: "\n\t\(event.address)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: color]))
        self.eventAddressLabel.attributedText = attributedText
        
        self.eventgroupNameLabel.attributedText = NSMutableAttributedString(string: " \(event.groupName)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold), NSForegroundColorAttributeName: color])
        
        let peopleAttribultedText =  NSMutableAttributedString(string: "👥", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold), NSForegroundColorAttributeName: color])
        peopleAttribultedText.append(NSMutableAttributedString(string: "   \(event.yesRSVP) people are going ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold), NSForegroundColorAttributeName: color]))
        self.yesRSVPLabel.attributedText = peopleAttribultedText
        
        
        
    }
}
