//
//  APIManager.swift
//
//  Created by Kashan Qamar on 15/11/2020.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON


class APIManager {
    
    
    static let baseUrl = "http://www.loyalbooks.com/"
    
    typealias parameters = [String:Any]
    
    enum FileDownloadResult {
        case success(String)
        case failure(RequestError)
    }
    
    enum ApiResult {
        case success(JSON)
        case failure(RequestError)
    }
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    enum RequestError: Error {
        case unknownError
        case connectionError
        case authorizationError(JSON)
        case invalidRequest
        case notFound
        case invalidResponse
        case serverError
        case serverUnavailable
    }
    
    
    static func downloadText(url:String,method:HTTPMethod,parameters:parameters?,completion: @escaping (FileDownloadResult)->Void) {
        let url = URL(string: baseUrl+"download/text/Railway-Children-by-E-Nesbit.txt")!

        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            if let localURL = localURL {
                if let bookText = try? String(contentsOf: localURL) {
                    completion(FileDownloadResult.success(bookText))
                }
                else {
                    completion(FileDownloadResult.failure(.unknownError))
                }
            }
        }
        task.resume()
    }
    
}
