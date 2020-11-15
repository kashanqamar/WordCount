//
//  ViewController.swift
//  WordCount
//
//  Created by Kashan Qamar on 15/11/2020.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {
    
    var tableView = UITableView()
    
    var words : [String] = []
    var counts : [Int] = []
    
    var bookViewModel = BookViewModel()
    
    let disposeBag = DisposeBag()

    public var book = PublishSubject<Array<Book>>()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
                
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.white
                
        tableView.contentInset.top = 20
        let contentSize = self.tableView.contentSize
        let footer = UIView(frame: CGRect(x: self.tableView.frame.origin.x,
                                          y: self.tableView.frame.origin.y + contentSize.height,
                                          width: self.tableView.frame.size.width,
                                          height: self.tableView.frame.height - self.tableView.contentSize.height))
        
        self.tableView.tableFooterView = footer
        view.addSubview(tableView)
        
        // binding
        self.setupBindings()
        // get book text
        bookViewModel.requestData()
    }
    
    
    // MARK: - Bindings
    
    private func setupBindings() {
        
        // binding loading to vc
        bookViewModel.loading
            .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        // observing errors to show
        bookViewModel
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .error)
                case .serverMessage(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .warning)
                }
            })
            .disposed(by: disposeBag)
        
        
        bookViewModel
            .book
            .observeOn(MainScheduler.instance)
            .bind(to: book)
            .disposed(by: disposeBag)
        
        
        // binding book container
        
        tableView.register(UINib(nibName: "BookTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: BookTableViewCell.self))
        
        book.bind(to: tableView.rx.items(cellIdentifier: "BookTableViewCell", cellType: BookTableViewCell.self)) {  (row,book,cell) in
            cell.cellBook = book
            }.disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: disposeBag)
               
    }
    
}

