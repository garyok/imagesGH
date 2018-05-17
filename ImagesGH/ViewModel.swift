//
//  ViewModel.swift
//  ImagesGH
//
//  Created by Gary Zamorano on 5/16/18.
//  Copyright © 2018 Gary Zamorano. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    let searchText = Variable<String>("")
    let disposeBag = DisposeBag()
   
    
    lazy var data: Driver<[Repository]> = {
        return self.searchText.asObservable()
        .throttle(0.3, scheduler: MainScheduler.instance)
        .distinctUntilChanged()
            .flatMapLatest({
                self.getRepositories(githubID: $0)
            }).asDriver(onErrorJustReturn: [])
    }()
    
    
    
    func getRepositories(githubID: String) -> Observable<[Repository]> {
        guard !githubID.isEmpty,
            let url = NSURL(string: "https://api.github.com/users/\(githubID)/repos")
            else {
                return Observable.just([])
        }
        return URLSession.shared.rx.json(url: url as URL)
        .retry(3)
            .map({
              var repositories = [Repository]()
              
                if let items = $0 as? [(AnyObject)]{
                    items.forEach({
                        guard let name = $0["name"] as? String,
                            let url = $0["html_url"] as? String
                    else {return}
                    repositories.append(Repository(name: name, url: url))
                    })
                }
              return repositories
            })
    }
}
