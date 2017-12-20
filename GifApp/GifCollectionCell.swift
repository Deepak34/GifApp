//
//  GifCollectionCell.swift
//  leg
//
//  Created by Deepak Venkatesh on 2017-12-14.
//  Copyright © 2017 Deepak Venkatesh. All rights reserved.
//

import UIKit
import FLAnimatedImage

class GifCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "collectionCell"
    
    @IBOutlet weak var imageView: FLAnimatedImageView!
    
    @IBOutlet var someBackgroundView: UIView!
    @IBOutlet var heartButton: UIButton!
    @IBOutlet var bottomView: UIView!
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func setUp(){
        bottomView.backgroundColor = UIColor.white//UIColor.black.withAlphaComponent(0.75)
        heartButton.setImage(#imageLiteral(resourceName: "starIconFIlled"), for: .normal)
        heartButton.changeToColor(UIColor.orange)//UIColor(red: 255/255, green: 95/255, blue: 0, alpha: 1))

        
        imageView.clipsToBounds = true
        //imageView.layer.cornerRadius = 5
        someBackgroundView.layer.shadowColor = UIColor.black.cgColor
        someBackgroundView.layer.shadowOpacity = 0.1
        someBackgroundView.layer.shadowOffset = CGSize.zero
        someBackgroundView.layer.shadowRadius = 2
        someBackgroundView.layer.borderWidth = 1
        someBackgroundView.layer.borderColor = UIColor(white: 0.88, alpha: 1).cgColor
        // someBackgroundView.layer.cornerRadius = 8

        
    }
    
}
