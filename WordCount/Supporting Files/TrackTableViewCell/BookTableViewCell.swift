//
//  BookTableViewCell.swift
//
//  Created by Kashan Qamar on 15/11/2020.
//

import UIKit


class BookTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var word : UILabel!
    @IBOutlet weak var wordCount: UILabel!
    
    
    public var cellBook : Book? {
        didSet {
            self.word.clipsToBounds = true
            self.wordCount.layer.cornerRadius = 3
            
            self.word?.text = "Word :- \(cellBook?.word ?? "") "
            self.wordCount?.text = "Word Count :- " + String(cellBook?.count ?? 0) + " - Prime No. :- " + String(cellBook?.isPrime ?? false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
}
