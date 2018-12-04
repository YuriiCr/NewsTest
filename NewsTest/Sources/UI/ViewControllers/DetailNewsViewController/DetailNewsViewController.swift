//
//  DetailNewsViewController.swift
//  NewsTest
//
//  Created by Yurii Sushko on 12/4/18.
//  Copyright © 2018 Yurii Sushko. All rights reserved.
//

import UIKit
import SafariServices

class DetailNewsViewController: UIViewController {
    
    //MARK: Properties
    
    var article = NewsModel()
    
    //MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        fillView()
    }
    
    //MARK: IBActions
    
    @IBAction func moreAction(_ sender: UIButton) {
        showSafariView()
    }
    
    
    //MARK: Private functions
    
    private func fillView() {
        let rv = self.rootView
        rv?.titleLAbel.text = article.title
        rv?.authorLabel.text = article.author
        rv?.contentLabel.text = article.content
        rv?.publishedDateLAbel.text = article.publishedAt
        
        fillImageVeiw()
    }
    
    private func fillImageVeiw() {
        guard let urlString = article.urlToImage else { return }
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global(qos: .background).async {
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async { [weak self] in
                self?.rootView?.articleImageView.image = image
            }
        }
    }
    
    private func showSafariView() {
        guard let stringUrl = article.url else { return }
        guard let url = URL(string: stringUrl) else { return }
        let sagafiController = SFSafariViewController(url: url)
        self.navigationController?.pushViewController(sagafiController, animated: true)
    }
    
    private func prepareNavigationBar() {
        let rightButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    @objc func share() {
        guard let stringUrl = article.url else { return }
        guard let url = URL(string: stringUrl) else { return }
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension DetailNewsViewController: RootView {
    
    //MARK: Root view
    
    typealias ViewType = DetailView
    
}
