//
//  HistoryPageViewController.swift
//  WyQi
//
//  Created by Shantanu Dutta on 27/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import UIKit
import ChameleonFramework
import SVProgressHUD

class HistoryPageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel = HistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        navigationController?.navigationBar.tintColor = FlatBlack()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = false
        self.title = "History"
        viewModel.historyObjects.bind { [unowned self] (array) in
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func clearHistoryData(_ sender: UIBarButtonItem) {
        viewModel.clearData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = false
        self.title = "History"
        DispatchQueue.global().async { [unowned self] in
            self.viewModel.retriveHistoryData()
        }
    }
    
    func displayWebView(with pageInfo:PageInfo) {
        guard viewModel.isReachable else {
            SVProgressHUD.showError(withStatus: "Device Offline !!! Please try later :)")
            return
        }
        if let viewController = WebViewController.controllerFromStoryboard(){
            viewController.viewModel.pageInfo = pageInfo
            OperationQueue.main.addOperation {
                if let navigator = self.navigationController {
                    navigator.navigationBar.prefersLargeTitles = false
                    self.tabBarController?.tabBar.tintColor = UIColor.clear
                    self.tabBarController?.tabBar.isHidden = true
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }else{
            SVProgressHUD.showError(withStatus: "Link cannot be displayed")
        }
    }
}

extension HistoryPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = viewModel.numberOfSections()
        if sections > 0 {
            if let _ = tableView.backgroundView {
                tableView.backgroundView = nil
            }
            return sections
        }else {
            // Displaying a message when the table is empty
            let messagelabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.bounds.size.width, height: CGFloat(20)))
            messagelabel.text = "No history searches"
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
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTVCell", for: indexPath) as! HistoryTVCell
        cell.viewModel = viewModel.viewModelForCell(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let siteInfo = viewModel.savedInfo(for: indexPath.row)
        displayWebView(with: siteInfo)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.1) {
            cell.alpha = 1.0
        }
    }
}
