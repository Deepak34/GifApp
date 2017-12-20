import Foundation
import UIKit


//This class is for accessing the plist, so you can save your favourite gifs. Saves as a Dicionary of [url:imageSize]. 
class PlistHelper:NSObject{
    
    var favourites:[URL] = []
    
    override init(){
        super.init()
        favourites = getFavouriteUrls()
    }
    
    func refreshFavourites(){
        favourites = getFavouriteUrls()
    }
    
    func getFavouriteUrls()->[URL]{
        
        var urls:[URL] = []
        
        let dataVersion = readPlist(namePlist: "Favourites", key: "gifs")
        
        let dict = dataVersion as? [String:[String:Int]] ?? [:]
        let urlStrings = Array(dict.keys)
        
        for string in urlStrings{
            let url = URL(string: string)
            urls.append(url!)
        }
        return urls
    }
    
    func getFavouriteUrlsAndSizes()->[String:[String:Int]]{
        let dataVersion = readPlist(namePlist: "Favourites", key: "gifs")
        let dict = dataVersion as? [String:[String:Int]] ?? [:]
        return dict
    }
    
    func addToFavourites(url:URL,size:(Int,Int)){
        let dataVersion = readPlist(namePlist: "Favourites", key: "gifs")
        var dict = dataVersion as? [String:[String:Int]] ?? [:]
        if (dict[url.absoluteString] != nil){
            dict[url.absoluteString] = nil
        }
        else{
            dict[url.absoluteString] = ["Width":size.0,"Height":size.1]
        }
        writePlist(namePlist: "Favourites", key: "gifs", data: dict as AnyObject)
        refreshFavourites()
    }
    
    
    func changeInFavourites(url:URL,size:(Int,Int) = (0,0)){
        if favourites.index(of: url) != nil{
            removeFromFavourites(url: url)
        }
        else{
            addToFavourites(url: url, size: size)
        }
    }
    func removeFromFavourites(url:URL){
        
        if let index = favourites.index(of: url){
            favourites.remove(at: index)
        }
        
        var urls = getFavouriteUrls()
        if let index = urls.index(of: url){
            urls.remove(at: index)
        }
        
        let urlStrings = urls.map({
            return $0.absoluteString
        })
        
        writePlist(namePlist: "Favourites", key: "gifs", data: urlStrings as AnyObject)
        refreshFavourites()
    }
    
    
    
    private func readPlist(namePlist: String, key: String) -> AnyObject?{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(namePlist+".plist")
        print(path)
        
        var output:AnyObject = false as AnyObject
        
        if (!FileManager.default.fileExists(atPath: path)){
            return NSMutableDictionary()
        }
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            output = dict.object(forKey: key) as AnyObject
        }else{
            if let privPath = Bundle.main.path(forResource: namePlist, ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    output = dict.object(forKey: key) as AnyObject
                }else{
                    output = false as AnyObject
                    print("error_read")
                }
            }else{
                output = false as AnyObject
                print("error_read")
            }
        }
        return output
    }
    private func writePlist(namePlist: String, key: String, data: AnyObject){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(namePlist+".plist")
        
        if (!FileManager.default.fileExists(atPath: path)){
            let someData = NSMutableDictionary(object: data, forKey: key as NSCopying)
            _ = someData.write(toFile: path, atomically: true)
            return
        }
        if let dict = NSMutableDictionary(contentsOfFile: path){
            dict.setObject(data, forKey: key as NSCopying)
            if dict.write(toFile: path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = Bundle.main.path(forResource: namePlist, ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    dict.setObject(data, forKey: key as NSCopying)
                    if dict.write(toFile: path, atomically: true){
                        print("plist_write")
                    }else{
                        print("plist_write_error")
                    }
                }else{
                    print("plist_write")
                }
            }else{
                print("error_find_plist")
            }
        }
    }
}

