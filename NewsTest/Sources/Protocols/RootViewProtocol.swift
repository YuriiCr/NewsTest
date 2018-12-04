//
//  RootViewProtocol.swift
//  NewsTest
//
//  Created by Yurii Sushko on 12/4/18.
//  Copyright © 2018 Yurii Sushko. All rights reserved.
//

import UIKit

protocol RootView {
    associatedtype ViewType
    
    var rootView: ViewType? { get }
}

extension RootView where Self: UIViewController {
    var rootView: ViewType? {
        return self.viewIfLoaded as? ViewType
    }
}
