//
//  NewsModel.swift
//  NewsTest
//
//  Created by Yurii Sushko on 12/3/18.
//  Copyright © 2018 Yurii Sushko. All rights reserved.
//

import Foundation

struct NewsModel {
    
    // MARK: Public properties
    
    var sourceId: String?
    var sourceName: String?
    var author: String?
    var title: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    static func newsModel(from savedNews: News) -> NewsModel {
        var news = NewsModel()
        news.sourceId = savedNews.sourceId
        news.sourceName = savedNews.sourceName
        news.content = savedNews.content
        news.title = savedNews.title
        news.url = savedNews.url
        news.urlToImage = savedNews.urlToImage
        news.publishedAt = savedNews.publishedAt
        news.content = savedNews.content
        
        return news
    }
    
}
