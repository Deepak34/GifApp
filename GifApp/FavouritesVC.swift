//
//  CollectionViewController.swift
//  GiphySwift-Example
//
//  Created by Matias Seijas on 9/29/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//
import UIKit
import GiphySwift
import FLAnimatedImage
import RxSwift


//The view controller for the Trending Tab.
//Uses MVVM design patterns, with RXSwift to communicate between the View Model and View Controller
//uses pinterest collection view layout, to adapt for gifs that are of different sizes.
class FavouritesVC: UICollectionViewController,UICollectionViewDelegateFlowLayout,PinterestLayoutDelegate {

    var viewModel = FavouritesViewModel()
    
    var noItemsLabel = UILabel()

    var disposeBag = DisposeBag()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noItemsLabel.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNoItemsLabel()
        setUpNavigationController()
        setUpCollectionView()
        attachObservables()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.refreshFavourites()
        (collectionView?.collectionViewLayout as! PinterestLayout).purgeCache()
        collectionView?.reloadData()
        
    }
    
    
    //attaches swiftRX observables for the no items label and the collection view
    func attachObservables(){
        viewModel.urls.asObservable().subscribe(onNext: {urls in
            
            DispatchQueue.main.async {
                if urls.count == 0{
                    self.noItemsLabel.isHidden = false
                }
                else{
                    self.noItemsLabel.isHidden = true
                }
            }
            
            
        }).addDisposableTo(disposeBag)
        
        
        viewModel.urls.asObservable().bind(to: collectionView!.rx.items(GifCollectionCell.reuseIdentifier, cellType: GifCollectionCell.self)) { (someCollection, url, cell) in
            
            self.viewModel.getImageForCell(cell: cell, url: url)
            
            cell.heartButton.addTarget(self, action: #selector(FavouritesVC.heartButtonTapped(sender:)), for: .touchUpInside)
            }.addDisposableTo(disposeBag)
    }

    
    func setUpNoItemsLabel(){
        noItemsLabel.numberOfLines = 0
        noItemsLabel.text = "No favourite gifs...\nStart finding some!!"
        noItemsLabel.font = TextHelper.NoPostsFont()
        noItemsLabel.textColor = TextHelper.globalGreyColor
        noItemsLabel.sizeToFit()
        view.addSubview(noItemsLabel)
        noItemsLabel.isHidden = true
        noItemsLabel.textAlignment = .center

    }
    
    func setUpNavigationController(){
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSFontAttributeName: TextHelper.HeaderFont()]

    }
    
    func setUpCollectionView(){
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView?.dataSource = nil
        collectionView?.alwaysBounceVertical = true
        collectionView?.bounces = true
        collectionView?.backgroundColor = UIColor.groupTableViewBackground
        
    }
    
    //when the heart button is tapped, unfavourite the item and remove it from the collection view
    func heartButtonTapped(sender:UIButton){
        var someView = sender.superview!
        
        while !(someView is GifCollectionCell){
            someView = someView.superview!
        }
        let cell = someView as! GifCollectionCell
        if let indexPath = collectionView?.indexPath(for: cell){
           
             (collectionView?.collectionViewLayout as! PinterestLayout).purgeCache()
            DispatchQueue.main.async {
                self.viewModel.changeInFavourites(url: self.viewModel.urls.value[indexPath.item])
                self.collectionView?.reloadData()
            }
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return viewModel.getItemHeight(item: indexPath.item)
    }
}
