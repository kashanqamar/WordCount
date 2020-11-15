//
//  BookViewModel.swift
//
//  Created by Kashan Qamar on 15/11/2020.
//

import Foundation
import RxSwift
import RxCocoa



class BookViewModel {
    
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let book : PublishSubject<Array<Book>> = PublishSubject()
    
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    
    public func requestData() {
        
        self.loading.onNext(true)
        APIManager.downloadText(url: "download/text/Railway-Children-by-E-Nesbit.txt", method: .get, parameters: nil, completion: { (result) in
            self.loading.onNext(false)
            switch result {
            case .success(let bookText) :
                self.book.onNext(self.getWordCount(text: bookText))                
            case .failure(let failure) :
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
            }
        })
        
    }
    
    
    func getWordCount(text : String) -> Array<Book>{
        var wordDictionary : [String : Int] = [:]
        // empty dictionary of keys as string and value as integer
        let words = text.components(separatedBy: " ")
        // if word does not exist in dictinary
        for word in words {
            if(wordDictionary[word] == nil) {
                // add the word with value 1
                wordDictionary[word] = 1
            }
            else {
                // if exists increment the value
                wordDictionary[word] = wordDictionary[word]! + 1
            }
        }
                            
        let sortedDict = wordDictionary.sorted { $0.1 > $1.1 }
        var wordObjectArray : Array<Book> = Array()
        
        for o in sortedDict {
            let obj = Book(word: o.key, count: o.value, isPrime: o.value.isPrime)
            wordObjectArray.append(obj)
        }
        
        return wordObjectArray
    }
}

extension Int {
    var isPrime: Bool {
        guard self >= 2     else { return false }
        guard self != 2     else { return true  }
        guard self % 2 != 0 else { return false }
        return !stride(from: 3, through: Int(sqrt(Double(self))), by: 2).contains { self % $0 == 0 }
    }
}

