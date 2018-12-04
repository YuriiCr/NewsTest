//
//  NewsTableViewCell.swift
//  NewsTest
//
//  Created by Yurii Sushko on 12/4/18.
//  Copyright © 2018 Yurii Sushko. All rights reserved.
//

import UIKit
import Kingfisher

class NewsTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets

    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    // MARK: properties
    
    var news: NewsModel? {
        didSet {
            fillLabels()
            fillImageView()
        }
    }
    
    // MARK: Private Functions
    
    private func fillLabels() {
        self.titleLabel.text = news?.title
        self.contentLabel.text = news?.content
    }
    
    private func fillImageView() {
        guard let urlString = news?.urlToImage else { return }
        guard let url = URL(string: urlString) else { return }
        let resource = ImageResource(downloadURL: url)
        self.newsImageView?.kf.setImage(with: resource)
    }
    
}
