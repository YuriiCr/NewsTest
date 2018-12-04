//
//  CoreDataManager.swift
//  NewsTest
//
//  Created by Yurii Sushko on 12/3/18.
//  Copyright © 2018 Yurii Sushko. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    //MARK: Singleton
    
    static let shared = CoreDataManager()
    private init() {}
    
    //MARK: Private properties
    
    private var container: NSPersistentContainer? {
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    //MARK: Methods
    
    func deleteAll() {
        container?.performBackgroundTask({ (context) in
            News.deleteAll(in: context)
        })
    }
    
    func saveNews(with article: NewsModel) {
        container?.performBackgroundTask({ (context) in
            News.createSavedNews(from: article, in: context)
        })
    }
    
    func newsFromCoreData(block: @escaping ([News]) -> ()) {
        container?.performBackgroundTask({ (context) in
            let result = News.allNews(in: context)
            block(result)
        })
    }
    
}
