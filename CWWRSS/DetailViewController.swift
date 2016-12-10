//
//  DetailViewController.swift
//  CWWRSS
//
//  Created by Richard Martin on 2016-12-06.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var webView: UIWebView!
    var articleToDisplay:Article?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let article = articleToDisplay {
            // article exists. load into webview.
            
            let uLink = URL(string: article.articleLink)
            if let url = uLink {
                let request = URLRequest(url: url)
                webView.loadRequest(request)
            }
        }
    }
}
