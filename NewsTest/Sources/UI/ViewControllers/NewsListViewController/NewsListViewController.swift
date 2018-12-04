//
//  NewsListViewController.swift
//  NewsTest
//
//  Created by Yurii Sushko on 12/3/18.
//  Copyright © 2018 Yurii Sushko. All rights reserved.
//

import UIKit

class NewsListViewController: UIViewController {
    
    //MARK: Properties
    
    private var newsArray = [NewsModel]()
    private let cellIndetifer = "newsCell"
    
    private var pageNumber = 2
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? NewsTableViewCell else { return }
        guard let vc = segue.destination as? DetailNewsViewController else { return }
        cell.news.map { vc.article = $0 }
        }
    
    //MARK: IBActions
    
    @IBAction func reloadData(_ sender: UIBarButtonItem) {
        self.pageNumber = 2
        if InternetService.isConnectedToInternet() {
            loadDataFromInternet()
        } else {
            showAlert()
            loadDataFromCoreData()
        }
    }
    
    //MARK: Private functions
    
    private func loadData() {
        InternetService.isConnectedToInternet() ?
            loadDataFromInternet() : loadDataFromCoreData()
    }
    
    private func loadDataFromInternet() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            InternetService.shared.getNews { (news) in
                CoreDataManager.shared.deleteAll()
                self?.newsArray = news
                _ = news.map { CoreDataManager.shared.saveNews(with: $0) }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func loadNextData() {
        let number = self.pageNumber
        DispatchQueue.global(qos: .background).async { [weak self] in
            InternetService.shared.getNews(page: number, block: { (news) in
                self?.pageNumber += 1
                for article in news {
                    self?.newsArray.append(article)
                    CoreDataManager.shared.saveNews(with: article)
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
        }
    }
    
    private func loadDataFromCoreData() {
        CoreDataManager.shared.newsFromCoreData {[weak self] news in
            let result = news.map { NewsModel.newsModel(from: $0) }
            self?.newsArray = result
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: Constants.alertTitle, message: Constants.alertMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: Constants.alertAction, style: .default)
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }

}

extension NewsListViewController: UITableViewDelegate {
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewsListViewController: UITableViewDataSource {
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIndetifer, for: indexPath) as? NewsTableViewCell else {  return UITableViewCell() }
        cell.news = newsArray[indexPath.row]
        
        if indexPath.row % 15 == 0 {
            loadNextData()
        }
        
        return cell
    }
    
}

extension NewsListViewController {
    private struct Constants {
        static let alertMessage = "No internet access"
        static let alertTitle = "Message"
        static let alertAction = "OK"
    }
}


