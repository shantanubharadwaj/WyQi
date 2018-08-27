//
//  SearchViewController.swift
//  WyQi
//
//  Created by Shantanu Dutta on 26/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import UIKit
import ChameleonFramework
import SVProgressHUD

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        navigationController?.navigationBar.tintColor = FlatBlack()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = false
        self.title = "Search"
        viewModel.pages.bind { [unowned self] (array) in
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
        viewModel.isSearchInProgress.bind { (status) in
            OperationQueue.main.addOperation {
                if status {
                    if !UIApplication.shared.isNetworkActivityIndicatorVisible {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    }
                }else{
                    if UIApplication.shared.isNetworkActivityIndicatorVisible {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = false
        self.title = "Search"
    }
    
    func displayWebView(with url:URL) {
        if let viewController = WebViewController.controllerFromStoryboard(){
            viewController.loadURL = url
            OperationQueue.main.addOperation {
                if let navigator = self.navigationController {
                    navigator.navigationBar.prefersLargeTitles = false
                    self.tabBarController?.tabBar.isHidden = true
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = viewModel.numberOfSections()
        if sections > 0 {
            if let _ = tableView.backgroundView {
                tableView.backgroundView = nil
            }
            return sections
        }else if viewModel.isSearchInProgress.value == false {
            // Displaying a message when the table is empty
            let messagelabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.bounds.size.width, height: CGFloat(20)))
            messagelabel.text = "No recent searches yet"
            messagelabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            messagelabel.numberOfLines = 0
            messagelabel.textAlignment = .center

            var font = UIFont.preferredFont(forTextStyle: .body).withSize(20)
            font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
            messagelabel.font = font
            messagelabel.sizeToFit()

            tableView.backgroundView = messagelabel
            tableView.backgroundView?.backgroundColor = FlatWhite()
            tableView.backgroundColor = FlatWhite()
            tableView.separatorStyle = .none
            return sections
        }else{
            if let _ = tableView.backgroundView {
                tableView.backgroundView = nil
            }
            return sections
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTVCell", for: indexPath) as! SearchViewCell
        cell.viewModel = viewModel.viewModelForCell(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let siteURL = viewModel.siteURL(for: indexPath.row) {
            displayWebView(with: siteURL)
        }else{
            SVProgressHUD.showError(withStatus: "Website cannot be displayed")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.1) {
            cell.alpha = 1.0
        }
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.clearData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchValue = searchBar.text, !searchValue.isEmpty else { print("Please enter some valid values to search"); return }
        viewModel.query(for: searchValue)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange : \(String(describing: searchBar.text)) , searchText : \(searchText)")
        viewModel.query(for: searchText)
    }
}
