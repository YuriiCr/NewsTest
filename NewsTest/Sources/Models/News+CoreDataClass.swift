//
//  News+CoreDataClass.swift
//  NewsTest
//
//  Created by Yurii Sushko on 12/3/18.
//  Copyright © 2018 Yurii Sushko. All rights reserved.
//
//

import Foundation
import CoreData

@objc(News)
public class News: NSManagedObject {
    
    static func createSavedNews(from article: NewsModel, in context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "News", in: context) else { return }
        let savedNews = News(entity: entity, insertInto: context)
        savedNews.author = article.author
        savedNews.content = article.content
        savedNews.publishedAt = article.publishedAt
        savedNews.sourceId = article.sourceId
        savedNews.sourceName = article.sourceName
        savedNews.title = article.title
        savedNews.url = article.url
        savedNews.urlToImage = article.urlToImage
        
        try? context.save()
    }
    
    static func allNews(in context: NSManagedObjectContext) -> [News] {
        var result = [News]()
        let request: NSFetchRequest<News> = News.fetchRequest()
        let newsArray = try? context.fetch(request)
        if let newsArray = newsArray {
            _ = newsArray.map { result.append($0) }
        }
        
        return result
    }
    
    static func deleteAll(in context: NSManagedObjectContext) {
        let request: NSFetchRequest<News> = News.fetchRequest()
        let newsArray = try? context.fetch(request)
        if let newsArray = newsArray {
            _ = newsArray.map { context.delete($0) }
        }
        try? context.save()
    }

}
