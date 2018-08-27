//
//  SavedPageViewController.swift
//  WyQi
//
//  Created by Shantanu Dutta on 8/27/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import UIKit
import ChameleonFramework
import SVProgressHUD

class SavedPageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel = SavedViewModel()
    
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
        self.title = "Saved"
        viewModel.savedObjects.bind { [unowned self] (array) in
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = false
        self.title = "Saved"
        viewModel.retriveSavedData()
    }
    
    func displayWebView(with pageInfo:PageInfo) {
        if let viewController = WebViewController.controllerFromStoryboard(){
            viewController.viewModel.pageInfo = pageInfo
            if let _ = viewController.viewModel.pageInfo.imageSource {
                OperationQueue.main.addOperation {
                    if let navigator = self.navigationController {
                        navigator.navigationBar.prefersLargeTitles = false
                        self.tabBarController?.tabBar.isHidden = true
                        navigator.pushViewController(viewController, animated: true)
                    }
                }
            }else{
                SVProgressHUD.showError(withStatus: "Website cannot be displayed")
            }
        }else{
            SVProgressHUD.showError(withStatus: "Link cannot be displayed")
        }
    }
}

extension SavedPageViewController: UITableViewDelegate, UITableViewDataSource {
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
            messagelabel.text = "No saved searches"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedTVCell", for: indexPath) as! SavedPageTVCell
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
