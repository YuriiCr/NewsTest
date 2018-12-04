//
//  InternetSevice.swift
//  NewsTest
//
//  Created by Yurii Sushko on 12/3/18.
//  Copyright © 2018 Yurii Sushko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class InternetService {
    
    // MARK: Private properties
    
    private let apiKey = "61fde4d05c7142de8ca04af0fcabf62b"
    private let urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=61fde4d05c7142de8ca04af0fcabf62b"
    
    //MARK: Singlton
    
    static let shared = InternetService()
    private init() { }
    
    //MARK: Public functions
    
    func getNews(page: Int = 1, block: @escaping ([NewsModel]) -> ()) {
        let params = [Constants.pageSize: Constants.pageSizeCount, Constants.page : page]
        Alamofire.request(urlString,  parameters: params).responseJSON { [weak self] (response) in
            guard let response = response.value as? [String : Any] else { return }
            let responseJSON = JSON(response)
            guard let articles = responseJSON[Constants.articles].array else { return }
            var newsArray = [NewsModel]()
            
            for aritcle in articles {
                var news = NewsModel()
                news.author = aritcle[Constants.author].string
                news.content = aritcle[Constants.content].string
                news.url = aritcle[Constants.url].string
                news.urlToImage = aritcle[Constants.urlToImage].string
                news.sourceId = aritcle[Constants.source][Constants.id].string
                news.sourceName = aritcle[Constants.source][Constants.name].string
                news.publishedAt = aritcle[Constants.publishedAt].string
                news.title = aritcle[Constants.title].string
                let contentString = aritcle[Constants.content].string
                let stringContent = contentString.map { self?.fix(string: $0) }
                news.content = stringContent ?? contentString
                
                newsArray.append(news)
            }
            
            block(newsArray)
        }
    }
    
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
}

extension InternetService {
    private struct Constants {
        static let articles = "articles"
        static let publishedAt = "publishedAt"
        static let author = "author"
        static let content = "content"
        static let source = "source"
        static let id = "id"
        static let name = "name"
        static let title = "title"
        static let urlToImage = "urlToImage"
        static let url = "url"
        
        static let pageSize = "pageSize"
        static let pageSizeCount = 15
        static let page = "page"
    }
    
    private func fix(string: String) -> String {
        var str = string
        let index = str.lastIndex(of: "[")
        if let index = index {
            str = String(str[..<index])
            return str
        }
        
        return str
    }
}
