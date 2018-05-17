//
//  ViewController.swift
//  ImagesGH
//
//  Created by Gary Zamorano on 5/16/18.
//  Copyright © 2018 Gary Zamorano. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar { return searchController.searchBar}
    
    var viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        
        viewModel.data
            .drive(tableview.rx.items(cellIdentifier: "Cell")){
                _, repository, cell in
                cell.textLabel?.text = repository.name
                cell.detailTextLabel?.text = repository.url
        }
        .disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
        .map({""})
        .bind(to: viewModel.searchText)
        .disposed(by: disposeBag)
        
        viewModel.data.asDriver()
        .map({"\($0.count) Repositories"})
        .drive(navigationItem.rx.title)
        .disposed(by: disposeBag)
        
    }
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.text = "garyok"
        searchBar.placeholder = "Enter github id"
        tableview.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

