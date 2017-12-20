//
//  TrendingViewModel.swift
//  Giphy_Sample
//
//  Created by Deepak Venkatesh on 2017-12-19.
//  Copyright © 2017 Deepak Venkatesh. All rights reserved.
//

import Foundation
import GiphySwift
import RxSwift
import FLAnimatedImage


//the View model for the TrendingVC
class TrendingViewModel{
    
    //number of gifs to load at once
    let limit = 10
    
    //uses this to access and change your favourite gifs
    var plistHelper = PlistHelper()
    
    var hasPosts:Variable<Bool> = Variable(true)
    var loading:Variable<Bool> = Variable(false)
    
    private let queue = DispatchQueue(label: "GiphySample", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    //the data source
    var images:Variable<[GiphyImage]> = Variable([])
    
    
    func urlFor(image: GiphyImage) -> URL? {
        if let image = image as? GiphyImageResult {
            
            return URL(string: image.images.fixedHeight.downsampled.gif.url)
        }
        
        // NOTE: The Giphy API returns these URLs as HTTP - Here we convert them first to HTTPS
        if let image = image as? GiphyRandomImageResult {
            var urlComponents = URLComponents(string: image.images.fixedHeight.downsampled.gif.url)
            urlComponents?.scheme = "https"
            return urlComponents?.url
        }
        
        return nil
    }
    
    func isFavourite(url:URL)->Bool{
        return plistHelper.favourites.contains(url)
    }
    
    //retrivies and assigns the gif to the cell
    func getImageForCell(cell:GifTableCell,image:GiphyImage){
        
        guard let url = urlFor(image: image) else { fatalError("Unable to retrieve URL for image") }
        
        
        self.queue.async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                
                OperationQueue.main.addOperation {
                    DispatchQueue.main.async {
                        let gifImage = FLAnimatedImage(animatedGIFData: data)
                        
                        cell.someImageView.animatedImage = gifImage
                    }
                }
                
                }.resume()
        }
        cell.setUp(favourite: isFavourite(url: url))

    }
    
    

    func changeInFavourites(image:GiphyImageResult){
        let url = urlFor(image: image)!
        plistHelper.changeInFavourites(url: url, size: image.images.original.size)

    }
    
    func refreshFavourites(){
        plistHelper.refreshFavourites()
    }
    
    func getRowHeight(row:Int)->CGFloat{
        
        if let image = images.value[row] as? GiphyImageResult{
        let size = image.images.original.size
        let ratio = CGFloat(size.height)/CGFloat(size.width)
        return ratio * UIScreen.main.bounds.width + 60
        }
        else{
        return UIScreen.main.bounds.width
        }
        
    }
    
    //obtains gifs, given optional search parameter. If no search parameter given, gets trending gifs instead
    //if newQuery is disabled, appends laoded gifs to images array without clearing it (used for pagination)
    func requestGifs(text:String?,newQuery:Bool) {
        
        if loading.value{return}
        if newQuery{
            images.value = []
        }
        
        loading.value = true
        
        if let text = text{
            if text.isEmpty{
                Giphy.Gif.request(.trending, limit: limit, offset: images.value.count, rating: nil, completionHandler: processResult)
            }
            else{

                
                Giphy.Gif.request(.search(text), limit: limit, offset: images.value.count, rating: nil, completionHandler: processResult)
            }
        }
        
        else{
             Giphy.Gif.request(.trending, limit: limit, offset: images.value.count, rating: nil, completionHandler: processResult)
            
        }
        
    }
    
    //the completion handler for requesting gifs. 
    func processResult(result: Any) {
        if let result = result as? GiphyRequestResult {
        
            if case .success(let images) = result {
                
                for image in images.result{
                    self.images.value.append(image)
                }
            }
        }
        hasPosts.value = (images.value.count != 0)
        loading.value = false
    }
    
    
}
