//
//  GifTableCell.swift
//  Giphy_Sample
//
//  Created by Deepak Venkatesh on 2017-12-15.
//  Copyright © 2017 Deepak Venkatesh. All rights reserved.
//

import UIKit
import FLAnimatedImage


class GifTableCell: UITableViewCell {
    
    static let reuseIdentifier = "tableCell"
    
    @IBOutlet weak var someImageView: FLAnimatedImageView!
    
    @IBOutlet var heartButton: UIButton!
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var someBackgroundView: UIView!
    
    var favourite = false
    
    
    override func prepareForReuse() {
        someImageView.image = nil
    }
    
    func setUp(favourite:Bool){
        self.favourite = favourite
        bottomView.backgroundColor = UIColor.white
        
        heartButton.setImage(#imageLiteral(resourceName: "starIconFIlled"), for: .normal)
        if favourite{
            heartButton.changeToColor(UIColor.orange)
        }
        else{
            heartButton.changeToColor(UIColor(white: 0.88, alpha: 1))
        }
        
        someImageView.clipsToBounds = true
        someImageView.layer.cornerRadius = 5
        someBackgroundView.layer.shadowColor = UIColor.black.cgColor
        someBackgroundView.layer.shadowOpacity = 0.1
        someBackgroundView.layer.shadowOffset = CGSize.zero
        someBackgroundView.layer.shadowRadius = 2
        someBackgroundView.layer.borderWidth = 1
        someBackgroundView.layer.borderColor = UIColor(white: 0.88, alpha: 1).cgColor
    }
    
    func heartButtonClicked(){
        
        favourite = !favourite
        
        if !favourite{
            heartButton.changeToColor(UIColor(white: 0.88, alpha: 1))
            return
        }
        
        let center = self.heartButton.center
        let amount:CGFloat = 10
        let time = 0.08
        
        heartButton.changeToColor(UIColor.orange)
        
        UIView.animate(withDuration: time, animations: {
            self.heartButton.frame.size.width += amount
            self.heartButton.frame.size.height += amount
            self.heartButton.center = center
        }, completion: {_ in
            
            UIView.animate(withDuration: time, animations: {
                self.heartButton.frame.size.width -= amount
                self.heartButton.frame.size.height -= amount
                self.heartButton.center = center
            })
            
        })
    }
    
}
