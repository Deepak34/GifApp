//
//  TextHelper.swift
//  GifApp

import UIKit

//Some static methods and variables for standardizing text fonts and color
class TextHelper{
    
    static var globalGreyColor = UIColor(white: 0.75, alpha: 1)

    static func NoPostsFont()->UIFont{
        return UIFont(name: "AvenirNext-Regular", size: 21)!
    }
    
    static func HeaderFont()-> UIFont{
        
        let fontString = "AvenirNext-DemiBold"
        return UIFont(name: fontString, size: 21)!
    }
    
    
    static func SmallFont()-> UIFont{
        
        let fontString = "AvenirNext-Regular"
        return UIFont(name: fontString, size: 15)!
    }
    
    static func BodyFont()-> UIFont{
        
        let fontString = "AvenirNext-Medium"
        return UIFont(name: fontString, size: 17)!
    }
    
    
}
