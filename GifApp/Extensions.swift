//
//  Extensions.swift
//
//
//  Created by Deepak Venkatesh on 2017-12-16.
//
//

import Foundation
import UIKit

extension UIButton{
    
    func changeToColor(_ color:UIColor){
        if self.imageView == nil || self.imageView?.image == nil{
            return
        }
        if self.imageView?.image == UIImage(){return}
        let image = self.imageView!.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        setImage(image, for: UIControlState())
        //tintColor = color
        self.tintColor = color
        
    }
}
