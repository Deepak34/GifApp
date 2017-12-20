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
import RxCocoa
import RxSwift


//The view controller for the Trending Tab.
//Uses MVVM design patterns, with RXSwift to communicate between the View Model and View Controller
//Includes pagination (universal scrolling)
class TrendingVC: UITableViewController,UISearchBarDelegate{
    
    let searchController = UISearchController(searchResultsController: nil)

    var noItemsLabel = UILabel()
    
    var spinner = UIActivityIndicatorView()
    
    var viewModel = TrendingViewModel()
    
    var disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    private let queue = DispatchQueue(label: "GiphySample", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    
    override func viewDidLoad() {
        Giphy.configure(with: .publicKey)
        setUpView()
        setUpNavBar()
        setUpSearchController()
        setUpTableView()
        attachObservables()
    }
    
    
    //attaches the various RxSwift observables for communication with the View Model
    //subscribes to search bar text. Finds new gifs when text changes
    //observes viewModel.hasPosts, so it can show or hide the no items label
    //observers viewModel.loading, so it can show the loading indicator accordingly
    func attachObservables(){
        searchController.searchBar.rx.text.orEmpty.subscribe(onNext: { text in
            
            self.viewModel.requestGifs(text: text,newQuery:true)
            
        }).addDisposableTo(disposeBag)
        
        
        viewModel.hasPosts.asObservable().bind(to: self.noItemsLabel.rx.isHidden).addDisposableTo(disposeBag)
        
        viewModel.loading.asObservable().bind(to: self.spinner.rx.isAnimating).addDisposableTo(disposeBag)
        
        
        viewModel.images.asObservable().bind(to: self.tableView.rx.items("tableCell", cellType: GifTableCell.self)) { row, element, cell in
            
            self.viewModel.getImageForCell(cell: cell, image: element)
            cell.selectionStyle = .none
            cell.heartButton.addTarget(self, action: #selector(TrendingVC.heartButtonTapped(sender:)), for: .touchUpInside)
            
            }.addDisposableTo(disposeBag)
        
    }
    
    func setUpView(){
        
        
        
        view.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(spinner)
        
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.color = TextHelper.globalGreyColor
        spinner.hidesWhenStopped = true
        
        noItemsLabel.numberOfLines = 0
        noItemsLabel.text = "No gifs match your search :("
        noItemsLabel.font = TextHelper.NoPostsFont()
        noItemsLabel.textColor = TextHelper.globalGreyColor
        noItemsLabel.sizeToFit()
        view.addSubview(noItemsLabel)
        noItemsLabel.isHidden = true
        noItemsLabel.textAlignment = .center
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spinner.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        noItemsLabel.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
    }
    
    //refresh screen when switching between tabs
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.refreshFavourites()
        tableView.reloadData()
    }
    
    
    //when the scroll view reaches the bottom, load more gifs
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height >= scrollView.contentSize.height{
            viewModel.requestGifs(text: searchController.searchBar.text,newQuery: false)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.requestGifs(text: nil,newQuery:true)
    }

    //when the heart button is tapped, favourite or unfavourite the item
    func heartButtonTapped(sender:UIButton){
        var someView = sender.superview!
        
        while !(someView is GifTableCell){
            someView = someView.superview!
        }
        let cell = someView as! GifTableCell
        cell.heartButtonClicked()
        
        if let indexPath = tableView.indexPath(for: cell){
        self.viewModel.changeInFavourites(image: viewModel.images.value[indexPath.row] as! GiphyImageResult)
        
        }
    }

    func setUpNavBar(){
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSFontAttributeName: TextHelper.HeaderFont()]
    }
    
    func setUpTableView(){
        tableView.sectionHeaderHeight = 0
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.dataSource = nil
    }
    
    func setUpSearchController(){
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for gifs!"
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
            // searchController.searchBar.isTranslucent = true
       // searchController.searchBar.backgroundImage = nil
        searchController.searchBar.barTintColor = UIColor.groupTableViewBackground
        searchController.searchBar.tintColor = TextHelper.globalGreyColor
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getRowHeight(row: indexPath.item)
    }
  }
