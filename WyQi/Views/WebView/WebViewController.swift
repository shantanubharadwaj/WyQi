//
//  WebViewController.swift
//  WyQi
//
//  Created by Shantanu Dutta on 27/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var viewModel = WebViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(WebViewController.savePage)), animated: true)
        if let url = viewModel.siteURL() {
            loadRequest(url)
        }else{
            SVProgressHUD.showError(withStatus: "Website cannot be loaded")
        }
    }
    
    @objc func savePage() {
        viewModel.saveLoadedData()
    }
    
    internal class func controllerFromStoryboard() -> WebViewController? {
        let storyboard = UIStoryboard(name:"Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewVC")
        return vc as? WebViewController
    }
    
    internal func loadRequest(_ url: URL) {
        let urlRequest = URLRequest(url: url)
        self.webView.load(urlRequest)
    }
}
