//
//  FavouritesViewModel.swift
//  Giphy_Sample
//
//  Created by Deepak Venkatesh on 2017-12-19.
//  Copyright © 2017 Deepak Venkatesh. All rights reserved.
//

import Foundation
import GiphySwift
import RxSwift
import FLAnimatedImage

//view model for FavouritesVC
class FavouritesViewModel{
    
    var plistHelper = PlistHelper()
    
    private let queue = DispatchQueue(label: "GiphySample", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    var urls:Variable<[URL]> = Variable([])
    var sizes:Variable<[CGSize]> = Variable([])
    
    

    
    init() {
       refreshFavourites()
    }
    
    //checks if the given gif url has already been favourited
    func isFavourite(url:URL)->Bool{
        return plistHelper.favourites.contains(url)
    }
    
    //retrivies and assigns the gif to the cell
    func getImageForCell(cell:GifCollectionCell,url:URL){

        queue.async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                
                OperationQueue.main.addOperation {
                    DispatchQueue.main.async {
                        let gifImage = FLAnimatedImage(animatedGIFData: data)
                        cell.imageView.animatedImage = gifImage
                    }
                }
                
                }.resume()
        }
        
        cell.setUp()

        
    }
    
    
    //handles a change in the favouriting of the url
    func changeInFavourites(url:URL){
        plistHelper.removeFromFavourites(url: url)
        
        if let index = urls.value.index(of: url){
            urls.value.remove(at: index)
            sizes.value.remove(at: index)
        }

    }
    
    //get updated favourites dictionary from the Plist
    func refreshFavourites(){
        var favourites = plistHelper.getFavouriteUrlsAndSizes()
        let stringURLS = Array(favourites.keys)
        sizes.value = []
        for url in stringURLS{
            var sizeDict = favourites[url] ?? [:]
            
            sizes.value.append(CGSize(width: sizeDict["Width"] ?? 0, height: sizeDict["Height"] ?? 0))
        }
        
        
        urls.value = stringURLS.map({return URL(string:$0)!})

    }
    
    func getItemHeight(item:Int)->CGFloat{
        
        let size = sizes.value[item]
        
        let ratio = size.height/size.width
        
        return UIScreen.main.bounds.width/2 * ratio + 60
        
    }
    
}
