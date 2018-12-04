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
//        self.imageView.map { getImage(with: news?.urlToImage, to: $0) }
        guard let urlString = news?.urlToImage else { return }
        guard let url = URL(string: urlString) else { return }
        let resource = ImageResource(downloadURL: url)
        self.newsImageView?.kf.setImage(with: resource)
    }
    
    private func getImage(with urlString: String?, to imageView: UIImageView) {
        guard let urlString = urlString else { return }
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global(qos: .background).async {
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
    }
    
   
}
