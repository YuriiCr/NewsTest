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
        loadData()
    }
    
    
    //MARK: Private functions
    
    private func loadData() {
        InternetService.isConnectedToInternet() ?
            loadDataFromInternet() : loadDataFromCoreData()
    }
    
    private func loadDataFromInternet() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            InternetService.shared.getNews { (news) in
                self?.newsArray = news
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
       

    }
    
    private func loadDataFromCoreData() {
        
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
        
        return cell
    }
    
}


