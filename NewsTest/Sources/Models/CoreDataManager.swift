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
    
    
}
